# frozen_string_literal: true

# A distribution repository (repomd+appdata) with many packages
# https://github.com/openSUSE/libzypp/tree/master/zypp/parser/yum/schema
# https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html
#
class Repository < ApplicationRecord
  belongs_to :distribution
  has_many :packages
  has_many_attached :repodata_files

  validates :url, presence: true

  def sync
    if updateinfo?
      sync_updateinfo
    else
      sync_primary
      sync_appdata
      set_weight
    end
  end

  def resync
    update(revision: nil)
    sync
  end

  # private

  def sync_updateinfo
    logger.debug('Syncing updateinfo...')

    updateinfo_xml.elements('update').each do |update_hash|
      update_hash.deep_symbolize_keys!
      update_hash[:pkglist][:collection][:package].each do |package_hash|
        package = packages.find_by(name: package_hash[:name])

        next unless package

        package.update!(release: package_hash[:version])
      end
    end
  end

  def sync_primary
    logger.debug('Syncing primary...')

    primary_xml.elements('package').each do |package_hash|
      package_hash.deep_symbolize_keys!
      logger.debug("Trying to sync #{package_hash[:name]}...")
      package = packages.find_or_create_by(name: package_hash[:name])

      package.assign_attributes(package_hash.slice(:name, :url, :summary, :description))
      package.architectures << package_hash[:arch]
      package.architectures = package.architectures.uniq.compact
      package.license = package_hash[:format][:'rpm:license']
      package.release = package_hash[:version][:ver]
      package.increment('weight') if package.main_package?
      package.save!
    end
    cleanup_packages
  end

  def sync_appdata
    logger.debug('Trying to sync appdata...')
    appdata_xml.elements('component').each do |component_hash|
      component_hash.deep_symbolize_keys!
      logger.debug("Trying to sync appdata for #{component_hash[:pkgname]}...")
      package = packages.find_by(name: component_hash[:pkgname])
      next unless package

      # FIXME: Handle the translations of appdata.summary
      summary = component_hash[:summary]
      summary = summary.first if summary.is_a?(Array)

      # FIXME: Handle the translations of appdata.name
      title = component_hash[:name]
      title = title.first if title.is_a?(Array)

      # FIXME: Handle HTML components like <p> and translations....
      description = component_hash[:description]

      if component_hash[:screenshots]
        screenshots = component_hash[:screenshots].elements('screenshot').map { |screenshot| screenshot['image']['_content'] }
        screenshots.compact!
      end
      # FIXME: icons, how does that work with appdata-icons.tar.gz?
      #        XML is <icon type="cached" height="128" width="128">128x128/4Pane.png</icon>

      if component_hash[:categories]
        if component_hash[:categories][:category].is_a?(Array)
          component_hash[:categories][:category].map { |category| package.categories << Category.find_or_create_by(name: category) }
        else
          package.categories << Category.find_or_create_by(name: component_hash[:categories][:category])
        end
      end

      package.assign_attributes(title: title, summary: summary, description: description, appstream: true)
      package.increment('weight', 10)
      package.save!
      CacheScreenshotJob.perform_later(package.id, screenshots) if screenshots&.any?
    end

    true
  end

  def cleanup_packages
    packages_in_primary = primary_xml.elements('package').map { |package| package['name'] }
    packages_in_db = packages.pluck(:name)
    to_delete = packages_in_db.uniq - packages_in_primary.uniq

    to_delete.each do |package_name|
      packages.find_by(name: package_name).delete
      logger.debug("Deleted package #{package_name} from distribution #{distribution.name}")
    end
  end

  def repomd_xml
    filename = fetch_by_type(type: 'repomd')
    repomd_blob = repodata_files_blobs.find_by(filename: filename)
    Xmlhash.parse(repomd_blob.download)
  end

  def primary_xml
    xml_by_type(type: 'primary')
  end

  def appdata_xml
    xml_by_type(type: 'appdata')
  end

  def updateinfo_xml
    xml_by_type(type: 'updateinfo')
  end

  # FIXME: This method and everything below is a service...
  def xml_by_type(type:)
    empty_xml = Xmlhash.parse('<xml></xml>')

    filename = fetch_by_type(type: type)
    return empty_xml unless filename

    blob = repodata_files_blobs.find_by(filename: filename)
    return empty_xml unless blob

    Xmlhash.parse(blob.download)
  end

  def fetch_by_type(type:)
    full_url = repodata_url
    return fetch_repomd if type == 'repomd'

    filename = repomd_xml.elements('data').find { |element| element['type'] == type }['location']['href'].split('/').last
    full_url << filename
    return filename if repodata_files_blobs.find_by(filename: filename)

    response = http_connection(url: full_url.join('/')).get
    raise "Could not fetch #{full_url.join('/')}" unless response.success?

    logger.debug("Successfully fetched #{full_url.join('/')}")

    filepath = Rails.root.join('tmp', 'file-cache', "#{id}-#{filename}")
    File.binwrite(filepath, uncompress_gzip(response.body))
    repodata_files.attach(io: File.open(filepath), filename: filename, content_type: response.headers['content-type'])
    File.delete(filepath)

    filename
  end

  def repodata_url
    [url, 'repodata']
  end

  def fetch_repomd
    full_url = repodata_url
    full_url << 'repomd.xml'
    response = http_connection(url: full_url.join('/')).get
    raise "Could not fetch #{full_url.join('/')}" unless response.success?

    logger.debug("Successfully fetched #{full_url.join('/')}")

    download_revision = Xmlhash.parse(response.body)['revision']

    filename = "#{download_revision}-repomd.xml"
    return filename if repodata_files_blobs.find_by(filename: filename)

    filepath = Rails.root.join('tmp', 'file-cache', "#{id}-#{filename}")
    File.binwrite(filepath, response.body)
    repodata_files.attach(io: File.open(filepath), filename: filename, content_type: response.headers['content-type'])
    File.delete(filepath)

    update(revision: download_revision)

    filename
  end

  def http_connection(url:)
    Faraday.new(url) do |conn|
      conn.headers['User-Agent'] = 'software.opensuse.org'
      conn.use Faraday::FollowRedirects::Middleware
    end
  end

  # NOTE: Can't use the gzip Faraday middleware, it only considers the Content-Encoding header.
  #       But mirrors serve the gzip files, not the content of the repomd files encoded in gzip.
  #       So they only set the header "content-type"=>"application/x-gzip"...
  def uncompress_gzip(body)
    io = StringIO.new(body)
    gzip_reader = Zlib::GzipReader.new(io, encoding: 'ASCII-8BIT')
    gzip_reader.read
  end
end
