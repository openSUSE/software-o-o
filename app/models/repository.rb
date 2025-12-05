# frozen_string_literal: true

# A distribution repository with many packages
#
class Repository < ApplicationRecord
  belongs_to :distribution
  has_many :packages, dependent: :destroy
  has_many :patches, through: :packages
  has_many_attached :repodata_files

  validates :url, presence: true
  validates :url, uniqueness: { scope: :distribution }
  attribute :sync_id, :string, default: -> { SecureRandom.uuid }

  def sync
    # Each Repository has at least primary.xml...
    sync_primary
    # ...and possibly updateinfo.xml...
    sync_updateinfo
    # ...and/or appdata.xml
    sync_appdata
  end

  # private

  # Turns primary.xml <package> elements into a Package
  # https://github.com/openSUSE/libzypp/tree/master/zypp-logic/zypp/parser/yum/schema
  def sync_primary
    primary_xml.elements('package').each do |package_hash|
      package_hash.deep_symbolize_keys!
      package = if updateinfo # we do not to create packages from an update repos primary.xml
                  distribution.packages.find_by(name: package_hash[:name])
                else
                  packages.find_or_create_by(name: package_hash[:name])
                end
      next unless package

      package_attributes = package_hash.slice(:name, :url, :summary, :description)
      package_attributes[:license] = package_hash.dig(:format, :'rpm:license')
      package_attributes[:release] = package_hash.dig(:version, :ver)
      package_attributes[:architectures] = (package_hash[:arch] + package.architectures).uniq.compact

      package.assign_attributes(package_attributes.compact)
      next unless package.changed?

      package.save!
    end

    true
  end

  # Turns updateinfo.xml <update> elements into a Patch
  def sync_updateinfo
    updateinfo_xml.elements('update').each do |update_hash|
      update_hash.deep_symbolize_keys!

      package_hashes = if update_hash[:pkglist][:collection][:package].is_a?(Array)
                         update_hash[:pkglist][:collection][:package]
                       else
                         [update_hash[:pkglist][:collection][:package]]
                       end

      package_hashes.each do |package_hash|
        # we don't track src packages
        next if package_hash[:arch] == 'src'

        package = distribution.packages.find_by(name: package_hash[:name])

        unless package
          logger.info("WARNING: updateinfo.xml <update> element for a package that does not exist: #{distribution.name} / #{package_hash[:name]}")
        end
        next unless package

        # FIXME: handle
        # - "release"? as in<package epoch="0" version="1.10" release="lp155.4.4.1">
        # - issues as in package_hash[:references]
        patch = package.patches.find_or_initialize_by(name: update_hash[:id])
        patch.name = update_hash[:id]
        patch.kind = update_hash[:type]
        patch.created_at = Time.at(update_hash[:issued][:date].to_i).utc.to_datetime
        patch.assign_attributes(update_hash.slice(:title, :severity, :status, :description))
        patch.save!
      end
    end

    true
  end

  # Enhances Package data from appdata.xml <component> elements
  # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html
  def sync_appdata
    appdata_xml.search('component').each do |component|
      package = packages.find_by(name: component.search('pkgname').first.text)
      next unless package

      # attributes
      summary = component.search('summary').first&.text
      title = component.search('name').first&.text
      description = component.search('description').first&.to_html
      description = description.gsub('<description>', '').gsub('</description>', '') if description
      package_attributes = { title: title, summary: summary, description: description }.compact

      # screenshots / icons
      screenshots = component.search('screenshots/screenshot/image').map(&:text)
      # FIXME: how does appdata work with appdata-icons.tar.gz?
      #        XML is <icon type="cached" height="128" width="128">128x128/4Pane.png</icon>

      # categories
      categories = component.search('categories/category').map(&:text)
      categories.compact.each do |category|
        category = category.gsub('X-', '')
        category = 'YaST' if category.starts_with?('SuSE-YaST-')
        category = category.titleize
        category = category.gsub('Ya St', 'YaST')
        package.categories << Category.find_or_create_by(name: category)
        package.categories << Category.find_or_create_by(name: 'Multimedia') if %w[AudioVideo Audio Video].includes?(category)
      end

      CacheScreenshotJob.perform_later(package.id, screenshots) if screenshots&.any?
      package.assign_attributes(package_attributes)
      next unless package.changed?

      # having appdata makes a package more "important" while searching
      package.appstream = true
      package.increment('weight')
      package.save!
    end

    true
  end

  def repomd_xml
    xml_by_type(type: 'repomd')
  end

  def primary_xml
    xml_by_type(type: 'primary')
  end

  def updateinfo_xml
    xml_by_type(type: 'updateinfo')
  end

  # Uses Nokogiri::XML because the XML structure of appdata is way more complex
  # and includes HTML inside XML tags.
  def appdata_xml
    # return Nokogiri::XML(File.read('tmp/kwrite.xml')) # test data...
    empty_xml = Nokogiri::XML('<xml></xml>')

    filename = fetch_by_type(type: 'appdata')
    return empty_xml unless filename

    blob = repodata_files_blobs.find_by(filename: filename)
    return empty_xml unless blob

    Nokogiri::XML(blob.download)
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

    filepath = Rails.root.join('tmp', 'file-cache', "#{id}-#{filename}")
    File.binwrite(filepath, uncompress_gzip(response.body)) if filename.end_with?('.gz')
    File.binwrite(filepath, Zstd.decompress(response.body)) if filename.end_with?('.zst')

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
