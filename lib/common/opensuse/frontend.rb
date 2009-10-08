require 'net/http'
require 'uri'
require 'base64'
require 'rexml/document'

module Suse
  class Frontend

    class Error < StandardError; end

    class HTTPError < Error; end
    class UnauthorizedError < HTTPError; end
    class ForbiddenError < HTTPError; end
    class UnspecifiedError < HTTPError; end
    
    class TransportError < Error; end
    class ConnectionError < TransportError; end
    

    @@logger = RAILS_DEFAULT_LOGGER

    def self.logger
      @@logger
    end

    def logger
      @@logger
    end
    
    def initialize( frontend_url )
      uri = URI.parse( frontend_url )
      unless uri.is_a? URI::HTTP
        raise RuntimeError, "url to frontend server is not a valid HTTP url"
      end
      
      @http = Net::HTTP.new( uri.host, uri.port )
    end
    
    # HACK HACK HACK HACK HACK
    def get_log_chunk( project, package, repo, arch, offset=0 )
      path = "/result/#{project}/#{repo}/#{package}/#{arch}/log?nostream=1&start=#{offset}"
      logger.debug "--> get_log_chunk path: #{path}"
      do_get( path )
    end

    def get_source( opt={} )
      logger.debug "--> get_source: #{opt.inspect}"
      path = '/source'
      path += "/#{opt[:project]}" if opt[:project]
      path += "/#{opt[:package]}" if opt[:project] && opt[:package]
      path += "/#{opt[:filename]}" if opt[:filename]
      logger.debug "--> get_source path: #{path}"
      do_get( path )
    end

    def get_platform( opt={} )
      logger.debug "--> get_platform: #{opt.inspect}"
      path = '/platform'
      path += "/#{opt[:project]}" if opt[:project]
      path += "/#{opt[:platform]}" if opt[:platform]
      logger.debug "--> get_platforms path: #{path}"
      do_get( path )
    end

    def get_meta( opt={} )
      logger.debug "--> get_meta: #{opt.inspect}"
      path = '/source'
      path += "/#{opt[:project]}" if opt[:project]
      path += "/#{opt[:package]}" if opt[:project] && opt[:package]
      path += "/_meta"
      logger.debug "--> get_meta path: #{path}"
      do_get( path )
    end

    def get_link( opt={} )
      logger.debug "--> get_link: #{opt.inspect}"
      path = '/source'
      path += "/#{opt[:project]}"
      path += "/#{opt[:package]}"
      path += "/_link"
      logger.debug "--> get_link path: #{path}"
      do_get( path )
    end

    def get_result( opt={} )
      logger.debug "--> get_result: #{opt.inspect}"
      path = '/result/'
      path += opt[:project] + "/"
      
      if opt[:platform]
        path += opt[:platform] + "/"
      end
      
      if opt[:package]
        path +=  opt[:package] + "/"
      end
      
      path += "result"
      logger.debug "--> get_result path: #{path}"
      do_get( path )
    end

    def get_user( opt={} )
      path = '/person/'
      path += opt[:login]
      do_get( path )
    end

    def put_meta( data, opt={} )
      logger.debug "--> put_meta: #{opt.inspect}"
      path = '/source'
      path += "/#{opt[:project]}" if opt[:project]
      path += "/#{opt[:package]}" if opt[:project] && opt[:package]
      path += "/_meta"

      #logger.debug "I would do a put request to '#{path}' with following data:"
      #logger.debug data
      #return true
      
      logger.debug "--> put_meta path: #{path}"
      do_put( data, path )
    end

    def put_file( data, opt={} )
      logger.debug "--> put_file: #{opt.inspect}"
      path = "/source/#{opt[:project]}/#{opt[:package]}/#{opt[:filename]}"

      do_put( data, path )
    end

    def delete_file( opt={} )
      path = "/source/#{opt[:project]}/#{opt[:package]}/#{opt[:filename]}"

      do_delete( path )
    end

    def put_user( data, opt={} )
      path = "/person/#{opt[:login]}"

      do_put( data, path )
    end

    def put_platform( data, opt={} )
      path = "/platform/#{opt[:project]}/#{opt[:platform]}"

      do_put( data, path )
    end

    def cmd_package project, package, cmd
      path = "/source/#{project}/#{package}?#{cmd}"
      do_post( path )
    end

    #cred_proc has to be a proc object returning a list with two fields:
    #example: @transport.login( Proc.new {['user', 'pass']} )
    def login( cred_proc )
      @cred_proc = cred_proc
    end

    private

    def do_get( path )
      begin
        response = @http.start do |http|
          http.get path, http_header
        end

        handle_response( response )
      rescue SystemCallError => err
        raise ConnectionError, wrap_xml( :summary => err.to_s )
      end
    end
    
    def do_delete( path )
      begin
        response = @http.start do |http|
          http.delete path, http_header
        end

        handle_response( response )
      rescue SystemCallError => err
        raise ConnectionError, wrap_xml( :summary => err.to_s )
      end
    end
    
    def do_put( data, path )
      begin
        path = URI.escape( path )
        #STDERR.puts "The encoded URI: #{path}"
        response = @http.start do |http|
          http.put path, data, http_header
        end

        handle_response( response )
      rescue SystemCallError => err
        raise ConnectionError, wrap_xml( :summary => err.to_s )
      end
    end

    def do_post( path )
      begin
        path = URI.escape( path )
        response = @http.start do |http|
          http.post path, "", http_header
        end
        handle_response( response )
      rescue SystemCallError => err
        raise ConnectionError, wrap_xml( :summary => err.to_s )
      end
    end

    def handle_response( response )
      #logger.debug "server returned #{response.class}"

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        return response.read_body
      when Net::HTTPUnauthorized
        raise UnauthorizedError, error_doc( response.read_body )
      when Net::HTTPForbidden
        raise ForbiddenError, error_doc( response.read_body )
      when Net::HTTPClientError, Net::HTTPServerError
        raise UnspecifiedError, error_doc( response.read_body )
      end
      
      raise HTTPError, error_doc( response.read_body )
    end

    def error_doc( content )
      error_doc = nil
      begin
        error_doc = REXML::Document.new( content )
      rescue REXML::ParseException
        logger.debug "Suse::Frontend: parse exception when creating error doc"
        error_doc = wrap_xml( :content => content )
      end
      if error_doc.root.nil? or not %w|error status|.include? error_doc.root.name
        error_doc = wrap_xml( :content => content ) 
      end
      error_doc
    end

    def wrap_xml( opt={} )
      opt[:summary] ||= "Error parsing the error document, original document attached"
      opt[:code] ||= 500
      opt[:content] ||= ""

      error = <<-END_ERROR
      <error>
        <code>#{opt[:code]}</code>
        <summary>#{opt[:summary]}</summary>
        <content>#{REXML::Text.normalize(opt[:content])}</content>
      </error>
      END_ERROR
      REXML::Document.new( error )
    end

    def http_header

      cred = get_credentials
      header = {
        'User-agent'    => 'opensuse.frontendconnector/0.1',
        'Accept'        => 'text/xml; charset=utf-8'
      }
      if cred[:login] and cred[:passwd]
        logger.debug "Transport: Transmitting base auth"
        header['Authorization' ] = base64_auth_string
      elsif cred[:ichain_user]
        logger.debug "Transport: Transmitting iChain user"
        header['X-username'] = cred[:ichain_user] 
      end
      header
    end

    #returns hash with :user and :pass fields or nil
    def get_credentials
      return {} if @cred_proc.nil?
      cred = @cred_proc.call
      if cred.size() == 2
        {:login => cred[0], :passwd => cred[1]}
      elsif cred.size() == 1
        { :ichain_user => cred[0] }
      end
    end

    #returns base64 encoded auth string for use for basic auth in http header
    #(colon separated login and password)
    def base64_auth_string
      cred = get_credentials
      unless cred[:login] and cred[:passwd]
        # logger.debug "Credentials are not complete!"
	return ""
      end
      re = 'Basic ' + Base64.encode64( cred[:login]+':'+cred[:passwd] )
      # puts "Base64 String reply: #{re}"
      return re
    end
  end
end
