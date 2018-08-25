require 'open-uri'
require 'mini_magick'

# Class to cache and resize the screenshot of a given package
class Screenshot
  THUMBNAIL_WIDTH = "600"

  # @return [String] name of the package
  attr_reader :pkg_name
  # @return [String] original (remote) location of the screenshot
  attr_reader :source_url

  def initialize(pkg_name, source_url = nil)
    @pkg_name = pkg_name
    @source_url = source_url
  end

  # Relative path of the thumbnail, ready to be passed to #image_tag
  #
  # If the thumbnail is already available locally or is one of the default
  # images (i.e. there is no remote screenshot), it will return the correct
  # path right away.
  #
  # If the screenshot is available remotely but the thumbnail is still not
  # generated, it will generate the thumbnail before returning the url if
  # :fetch is true or will return nil if :fetch is false.
  #
  # @return [String]
  def thumbnail_path(fetch: true)
    begin
      generate_thumbnail unless cached? || !fetch || !source_url
    # This is sensitive enough (depending on an external system) to
    # justify an agressive rescue. #open can produce the following
    # rescue Errno::ETIMEDOUT, Net::ReadTimeout, OpenURI::HTTPError => e
    # And also there is a chance of exception generating the thumbnail
    rescue Exception => e
      raise unless Rails.env.production?
      Rails.logger.error("No screenshot fetched for: " + pkg_name)
    end

    if cached?
      generated_thumbnail_path
    else
      default_thumbnail_path
    end
  end

  # @return [Boolean] true if a proper thumbnail is available (not a default thumbnail)
  #
  # This is useful for carousel screenshots, where we don't want to show default thumbnails.
  def thumbnail_generated?
    cached?
  end

  protected

  def cached?
    File.exist?(File.join(Rails.root, "public", generated_thumbnail_path))
  end

  def generate_thumbnail
    Rails.logger.debug("Fetching screenshot from #{source_url}")
    img = MiniMagick::Image.open(source_url)
    img.resize THUMBNAIL_WIDTH
    file_path = File.join(Rails.root, "public", generated_thumbnail_path)
    img.write file_path
  end

  # Path to the generated thumbnail image
  # This is served from /public, and not from the asset pipeline.
  def generated_thumbnail_path
    "images/thumbnails/#{pkg_name}.png"
  end

  # Default thumbnail path, based on the package name.
  # This is served from the asset pipeline.
  def default_thumbnail_path
    file = case pkg_name
    when /-devel$/
      "devel-package.png"
    when /-devel-/
      "devel-package.png"
    when /-debug$/
      "devel-package.png"
    when /-lang$/
      "lang-package.png"
    when /-l10n-/
      "lang-package.png"
    when /-i18n-/
      "lang-package.png"
    when /-translations/
      "lang-package.png"
    when /-doc$/
      "doc-package.png"
    when /-help-/
      "doc-package.png"
    when /-javadoc$/
      "doc-package.png"
    when /-debuginfo/
      "devel-package.png"
    when /-debugsource/
      "devel-package.png"
    when /-kmp-/
      "devel-package.png"
    when /^rubygem-/
      "ruby-package.png"
    when /^perl-/
      "perl-package.png"
    when /^python-/
      "python-package.png"
    when /^python2-/
      "python-package.png"
    when /^python3-/
      "python-package.png"
    when /^kernel-/
      "kernel-package.png"
    when /^openstack-/i
      "openstack-package.png"
    else
      "package.png"
    end
    "default-screenshots/#{file}"
  end
end
