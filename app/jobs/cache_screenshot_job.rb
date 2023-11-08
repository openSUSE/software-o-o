# frozen_string_literal: true

# Fetches one or more screenshots from an array of urls and attaches it to a Package
class CacheScreenshotJob < ApplicationJob
  def perform(package_id, screenshot_urls = [])
    package = Package.find_by(id: package_id)
    return unless package

    package.screenshots.purge

    screenshot_urls.each do |url|
      begin
        response = http_connection(url: url).get
      rescue Faraday::ConnectionFailed, Faraday::SSLError
        logger.debug "Could not fetch #{url}..."
        next
      end

      unless response.success?
        logger.debug "Could not fetch #{url}..."
        next
      end

      filename = File.basename(URI.parse(url).path)
      filepath = Rails.root.join('tmp', 'file-cache', filename)
      File.binwrite(filepath, response.body)
      package.screenshots.attach(io: File.open(filepath), filename: filename, content_type: response.headers['content-type'])
      File.delete(filepath)
    end
    package.increment('weight', package.screenshots_attachments.count)
    package.save
  end

  private

  def http_connection(url:)
    Faraday.new(url) do |conn|
      store = ActiveSupport::Cache.lookup_store(:file_store, Rails.root.join('tmp', 'http-cache'))

      conn.headers['User-Agent'] = 'software.opensuse.org'
      conn.use Faraday::FollowRedirects::Middleware
      conn.use :http_cache, store: store, serializer: Marshal
    end
  end
end
