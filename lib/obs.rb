require 'faraday'

# HTTP OBS client for searches
module OBS
  # Error class for unsupported search terms
  class InvalidSearchTerm < StandardError; end

  # One binary that represents an rpm.
  # It has the following properties
  # Binary.arch => [String]
  # Binary.baseproject => [String]
  # Binary.filename => [String]
  # Binary.filepath => [String]
  # Binary.name => [String]
  # Binary.package => [String]
  # Binary.project => [String]
  # Binary.release => [String]
  # Binary.repository => [String]
  # Binary.type => [String]
  # Binary.version => [String]
  class Binary < Hashie::Mash
    include Hashie::Extensions::Mash::SymbolizeKeys
    def self.coerce(binary)
      binary = [binary] unless binary.is_a?(Array)
      binary.map { |bin| Binary.new(bin) }
    end
  end

  # A collection of one more binaries with the following properties
  # Collection.binaries => [Array] of [Binary]
  # Collection.matches  => [Integer]
  class Collection < Hashie::Mash
    include Hashie::Extensions::Mash::SymbolizeKeys
    include Hashie::Extensions::Coercion
    coerce_key :binary, Binary
    coerce_key :matches, Integer

    def self.coerce(hash)
      c = Collection.new(hash)
      c[:binaries] = c.delete(:binary)
      c
    end
  end

  # Helper class that turns a "collection" attribute in HTTP responses into an
  # instance of [Collection]
  class Response < Hashie::Mash
    include Hashie::Extensions::Mash::SymbolizeKeys
    include Hashie::Extensions::Coercion
    coerce_key :collection, Collection
  end

  # Utility function to generate a xpath query from a search term and the following options:
  # @param [Hash] opts the options for the query.
  # @option opts [String] :baseproject OBS base project used to search packages for
  # @option opts [String] :project OBS specific project used to search packages into
  # @option opts [Boolean] :exclude_debug Exclude Debug packages from search
  # @option opts [String] :exclude_filter Exclude packages containing this term
  #
  def self.xpath_for(query, opts = {})
    baseproject = opts[:baseproject]
    project = opts[:project]
    exclude_debug = opts[:exclude_debug]
    exclude_filter = opts[:exclude_filter]

    words = query.split(" ").reject { |part| part.match(/^[0-9_\.-]+$/) }
    versrel = query.split(" ").select { |part| part.match(/^[0-9_\.-]+$/) }
    Rails.logger.debug "splitted words and versrel: #{words.inspect} #{versrel.inspect}"
    raise InvalidSearchTerm, "Please provide a valid search term" if words.blank? && versrel.blank?
    raise InvalidSearchTerm, "The package name is required when searching for a version" if words.blank? && versrel.present?

    xpath_items = []
    xpath_items << "@project = '#{project}' " unless project.blank?
    substring_words = words.reject { |word| word.match(/^".+"$/) }.map { |word| "'#{word.gsub(/['"()]/, '')}'" }.join(", ")
    xpath_items << "contains-ic(@name, " + substring_words + ")" unless substring_words.blank?
    words.select { |word| word.match(/^".+"$/) }.map { |word| word.delete("\"") }.each do |word|
      xpath_items << "@name = '#{word.gsub(/['"()]/, '')}' "
    end
    xpath_items << "path/project='#{baseproject}'" unless baseproject.blank?
    xpath_items << "not(contains-ic(@project, '#{exclude_filter}'))" if !exclude_filter.blank? && project.blank?
    xpath_items << versrel.map { |part| "starts-with(@versrel,'#{part}')" }.join(" and ") unless versrel.blank?
    if exclude_debug
      xpath_items << "not(contains-ic(@name, '-debuginfo')) and not(contains-ic(@name, '-debugsource')) " \
                     "and not(contains-ic(@name, '-devel')) and not(contains-ic(@name, '-lang'))"
    end
    xpath = xpath_items.join(' and ')
    xpath
  end

  class << self
    attr_writer :client
    attr_reader :configuration
  end

  # Configure client
  #
  # @yield [configuration] configuration object to defining client parameters
  # @example
  #   OBS.configure do |config|
  #     config.api_key = "XYZ"
  #     config.adapter = :typhoeus
  #   end
  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?

    self.client = Faraday.new(@configuration.api_host) do |conn|
      conn.basic_auth @configuration.api_username, @configuration.api_password
      conn.request :url_encoded
      conn.response :logger, Rails.logger, headers: false
      conn.response :mashify, mash_class: Response
      conn.response :raise_error
      conn.use FaradayMiddleware::ParseXml, content_type: /\bxml$/
      conn.adapter @configuration.adapter
    end
  end

  def self.client
    @client || configure
  end

  # HTTP client configuration wrapper
  class Configuration
    attr_accessor :api_host, :api_username, :api_password, :adapter

    def initialize
      @adapter = Faraday.default_adapter
    end
  end

  # Searches for published binaries
  #
  # Passes these options to xpath_for:
  # @param [String] query term to search for
  # @param [Hash] opts the options for the query.
  # @option opts [String] :baseproject OBS base project used to search packages for
  # @option opts [String] :project OBS specific project used to search packages into
  # @option opts [Boolean] :exclude_debug Exclude Debug packages from search
  # @option opts [String] :exclude_filter Exclude packages containing this term
  #
  def self.search_published_binary(query, opts = {})
    result = OBS.client.get('/search/published/binary/id', match: xpath_for(query, opts)).body.collection
    result.binaries.present? result.binaries : []
  end
end
