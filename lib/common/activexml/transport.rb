module ActiveXML
  module Transport

    class Error < StandardError; end
    class ConnectionError < Error; end
    class UnauthorizedError < Error; end
    class ForbiddenError < Error; end
    class NotFoundError < Error; end
    class NotImplementedError < Error; end

    class Abstract
      class << self
        def register_protocol( proto )
          ActiveXML::Config.register_transport self, proto.to_s
        end

        # spawn is called from within ActiveXML::Config::TransportMap.connect to
        # generate the actual transport instance for a specific model. May be
        # overridden in derived classes to implement some sort of connection
        # cache or singleton transport objects. The default implementation is
        # to create an own instance for each model.
        def spawn( target_uri, opt={} )
          self.new opt
        end

        def logger
          ActiveXML::Base.config.logger
        end
      end

      attr_accessor :target_uri

      def initialize( target_uri, opt={} )
      end

      def find( model, *args )
        raise NotImplementedError;
      end

      def query( model, query_string )
        raise NotImplementedError;
      end

      def save(object, opt={})
        raise NotImplementedError;
      end

      def delete(object, opt={})
        raise NotImplementedError;
      end

      def login( user, password )
        raise NotImplementedError;
      end

      def logger
        ActiveXML::Base.config.logger
      end
    end




    ##############################################
    #
    # BSSQL plugin
    #
    ##############################################



    require 'active_support'
    class BSSQL < Abstract
      register_protocol 'bssql'

      class << self
        def spawn( target_uri, opt={} )
          @transport_obj ||= new( target_uri, opt )
        end
      end

      def initialize( target_uri, opt={} )
        logger.debug "[BSSQL] initialize( #{target_uri.inspect}, #{opt.inspect} )"

        @xml_to_db_model_map = {
          :project => "DbProject",
          :package => "DbPackage"
        }
      end

      def xml_to_db_model( xml_model )
        unless @xml_to_db_model_map.has_key? xml_model
          raise RuntimeError, "no model association defined for '#{xml_model.inspect}'"
        end

        case xml_model
        when :project
          return DbProject
        when :package
          return DbPackage
        end
      end

      def find( model, *args )
        logger.debug "[BSSQL] find( #{model.inspect}, #{args.inspect} )"

        symbolified_model = model.name.downcase.to_sym
        uri = ActiveXML::Config::TransportMap.target_for( symbolified_model )
        options = ActiveXML::Config::TransportMap.options_for( symbolified_model )

        # get matching database model class
        db_model = xml_to_db_model( symbolified_model )

        query = String.new
        case args[0]
        when String
          params = args[1]
        when Hash
          params = args[0]
        when Symbol
          # :all
          params = args[1]
        else
          raise Error, "illegal parameter to find"
        end

        query = query_from_options( params )
        builder = Builder::XmlMarkup.new( :indent => 2 )

        if( query.empty? )
          items = db_model.find(:all) 
        else
          querymap = Hash.new
          query.split( /\s+and\s+/ ).map {|x| x.split(/=/) }.each do |pair|
            querymap[pair[0]] = pair[1]
          end

          join_fragments = Array.new
          cond_fragments = Array.new
          cond_values = Array.new

          querymap.each do |k,v|
            unless( md = k.match /^@(.*)/ )
              raise NotFoundError, "Illegal query: [#{query}]"
            end

            #unquote (I don't think this is safe enough...)
            v.gsub! /^['"]/, ''
            v.gsub! /['"]$/, ''

            #FIXME: hack for project parameter in Package.find
            if( symbolified_model == :package and md[1] == "project" )
              join_fragments << "db_projects"

              cond_fragments << ["db_packages.db_project_id = db_projects.id"]
              cond_fragments << ["db_projects.name = ?"]

              cond_values << v
              next
            end

            unless( db_model.column_names.include? md[1] )
              raise NotFoundError, "Unknown attribute '#{md[1]}' in query '#{query}'"
            end

            v.gsub! /([%_])/, '\\\\\1' #escape mysql LIKE special chars
            v.gsub! /\*/, '%'
            
            cond_fragments << ["#{db_model.table_name}.#{md[1]} LIKE BINARY ?"]
            cond_values << v
          end

          joins = nil
          unless join_fragments.empty?
            joins = ", " + join_fragments.join(", ")
            logger.debug "[BSSQL] join string: #{joins.inspect}"
          end

          conditions = [cond_fragments.join(" AND "), cond_values].flatten
          logger.debug "[BSSQL] find conditions: #{conditions.inspect}"

          items = db_model.find( :all, :select => "#{db_model.table_name}.*", :joins => joins, :conditions => conditions )
        end
        objects = Array.new
        xml = String.new

        if( args[0] == :all )
          items.sort! {|a,b| a.name.downcase <=> b.name.downcase}
          builder = Builder::XmlMarkup.new( :indent => 2 )
          xml = builder.directory( :count => items.length ) do |dir|
            items.each do |item|
              dir.entry( :name => item.name )
            end
          end
          return Directory.new( xml )
        end

        items.each do |item|
          logger.debug "---> "+item.methods.grep(/^to_a/).inspect
          #if not item.respond_to? :to_axml
          #  raise RuntimeError, "unable to transform to xml: #{item.inspect}"
          #end
          obj = model.new( item.to_axml )
          
          obj.instance_variable_set( '@init_options', params )
          objects << obj
        end
        
        if objects.length > 1 || args[0] == :all
          return objects
        elsif objects.length == 1
          return objects[0]
        else
          logger.debug "[BSSQL] query #{query} returned no objects"
          raise NotFoundError, "#{model.name.downcase} query \"#{query}\" produced no results"
        end
      end

      def login( user, password )
        return true
      end

      def save(object, opt={})
        logger.debug "[BSSQL] saving object #{object}"

        db_model = xml_to_db_model(object.class.name.downcase.to_sym)

        if db_model.respond_to? :store_axml
          db_model.store_axml( object )
        else
          raise Error, "[BSSQL] Unable to store objects of type '#{object.class.name}'"
        end
      end

      def query_from_options( opt_hash )
        logger.debug "[BSSQL] query_from_options: #{opt_hash.inspect}"
        query_fragments = Array.new
        opt_hash.each do |k,v|
          query_fragments << "@#{k}='#{v}'"
        end
        query = query_fragments.join( " and " )
        logger.debug "[BSSQL] query_from_options: query is: '#{query}'"
        return query
      end

      def xml_error( opt={} )
        default_opts = {
          :code => 500,
          :summary => "Default summary",
        }
        opt = default_opts.merge opt

        builder = Builder::XmlMarkup.new
        xml = builder.status( :code => opt[:code] ) do |s|
          s.summary( opt[:summary] )
          s.details( opt[:details] ) if opt.has_key? :details
        end

        xml
      end
    end


    ##############################################
    #
    # rest plugin
    #
    ##############################################


    #TODO: put lots of stuff into base class

    require 'base64'
    require 'net/https'
    require 'net/http'

    class Rest < Abstract
      register_protocol 'rest'
      
      class << self
        def spawn( target_uri, opt={} )
          @transport_obj ||= new( target_uri, opt )
        end
      end

      def initialize( target_uri, opt={} )
        logger.debug "[REST] initialize( #{target_uri.inspect}, #{opt.inspect} )"
        @options = opt
        if @options.has_key? :all
          @options[:all].scheme = "http"
        end
        @http_header = {"Content-Type" => "text/plain"}
      end

      def target_uri=(uri)
        uri.scheme = "http"
        @target_uri = uri
      end

      def login( user, password )
        @http_header ||= Hash.new
        @http_header['Authorization'] = 'Basic ' + Base64.encode64( "#{user}:#{password}" )
      end
      
      # returns document payload as string
      def find( model, *args )
        logger.debug "[REST] find( #{model.inspect}, #{args.inspect} )"
        params = Hash.new
        data = nil
        symbolified_model = model.name.downcase.to_sym
        uri = ActiveXML::Config::TransportMap.target_for( symbolified_model )
        options = ActiveXML::Config::TransportMap.options_for( symbolified_model )
        case args[0]
        when Symbol
          logger.debug "Transport.find: using symbol"
          #raise "Illegal symbol, must be :all (or String/Hash)" unless args[0] == :all
          uri = options[args[0]]
          if args.length > 1
            #:conditions triggers atm. always a post request, the conditions are
            # transmitted as post-data 
            if args[1].has_key? :conditions
              data = args[1][:conditions]
            end
            params = args[1].merge params
          end
        when String
          logger.debug "Transport.find: using string"
          params[:name] = args[0]
          if args.length > 1
            params = args[1].merge params
          end
        when Hash
          logger.debug "Transport.find: using hash"
          params = args[0]
        else
          raise "Illegal first parameter, must be Symbol/String/Hash"
        end

        logger.debug "uri is: #{uri}"
        url = substitute_uri( uri, params )
        
        #use get-method if no conditions defined <- no post-data is set.
        if data.nil?
          logger.debug"[REST] Transport.find using GET-method"
          obj = model.new( http_do( 'get', url ) )
          obj.instance_variable_set( '@init_options', params )
        else
        #use post-method
          logger.debug"[REST] Transport.find using POST-method"
          #logger.debug"[REST] POST-data as xml: #{data.to_s}"
          obj = model.new( http_do( 'post', url, data.to_s) )
          obj.instance_variable_set( '@init_options', params )
        end
        return obj
      end

      def save(object, opt={})
        logger.debug "saving #{object.inspect}"
        url = substituted_uri_for( object )
        http_do 'put', url, object.dump_xml
      end

      def delete(object, opt={})
        logger.debug "deleting #{object.inspect}"
        url = substituted_uri_for( object, :delete, opt )
        http_do 'delete', url
      end

      def start_keepalive
        logger.debug "starting keepalive..."
        symbolified_model = :project
        uri = ActiveXML::Config::TransportMap.target_for( symbolified_model )
        begin
          @http = Net::HTTP.start( uri.host, uri.port )
        rescue SystemCallError => err
          raise ConnectionError, "Failed to establish connection: "+err.message
        end
      end

      def finish_keepalive
        return if @http.nil?
        logger.debug "ending keepalive..."
        @http.finish
        @http = nil
      end

      # defines an additional header that is passed to the REST server on every subsequent request
      # e.g.: set_additional_header( "X-Username", "margarethe" )
      def set_additional_header( key, value )
        if value.nil? and @http_header.has_key? key
          @http_header[key] = nil
        end

        @http_header[key] = value
      end

      # delete a header field set with set_additional_header
      def delete_additional_header( key )
        if @http_header.has_key? key
          @http_header.delete key
        end
      end

      def direct_http( url, opt={} )
        defaults = {:method => "GET"}
        opt = defaults.merge opt

        #set default host if not set in uri
        if not url.host
          host, port = ActiveXML::Config::TransportMap.get_default_server( "rest" )
          url.host = host
          url.port = port unless port.nil?
        end

        logger.debug "--> direct_http url: #{url.inspect}"

        http_do opt[:method], url, opt[:data]
      end

      #replaces the parameter parts in the uri from the config file with the correct values
      def substitute_uri( uri, params )
        
        
        logger.debug "[REST] reducing args: #{params.inspect}"
        params.delete(:conditions)
        logger.debug "[REST] args is now: #{params.inspect}"        
        
        u = uri.clone
        u.scheme = "http"
        u.path = URI.escape(uri.path.split(/\//).map { |x| x =~ /^:(\w+)/ ? params[$1.to_sym] : x }.join("/"))
        if uri.query
          new_pairs = []
          pairs = u.query.split(/&/).map{|x| x.split(/=/, 2)}
          pairs.each do |pair|
            if pair.length == 2
              pair[1] =~ /:(\w+)/
              next if not params.has_key? $1.to_sym or params[$1.to_sym].nil?
              pair[1] = CGI.escape(params[$1.to_sym])
              new_pairs << pair.join("=")
            elsif pair.length == 1
              pair[0] =~ /:(\w+)/
              #new substitution rules:
              #when param is not there, don't put anything in url
              #when param is array, put multiple params in url
              #when param is a hash, put key=value params in url
              #any other case, stringify param and put it in url
              next if not params.has_key? $1.to_sym or params[$1.to_sym].nil?
              sub_val = params[$1.to_sym]
              if sub_val.kind_of? Array
                sub_val.each do |val|
                  new_pairs << $1 + "=" + CGI.escape(val)
                end
              elsif sub_val.kind_of? Hash
                sub_val.each_key do |key|
                  new_pairs << CGI.escape(key) + "=" + CGI.escape(sub_val[key])
                end
              else
                new_pairs << $1 + "=" + CGI.escape(sub_val.to_s)
              end
            else
              raise RuntimeError, "illegal url query pair: #{pair.inspect}"
            end
          end
          u.query = new_pairs.join("&")
        end
        u.path.gsub!(/\/+/, '/')
        return u
      end
      private :substitute_uri

      def substituted_uri_for( object, path_id=nil, opt={} )
        symbolified_model = object.class.name.downcase.to_sym
        options = ActiveXML::Config::TransportMap.options_for(symbolified_model)
        if path_id and options.has_key? path_id
          uri = options[path_id]
        else
          uri = ActiveXML::Config::TransportMap.target_for( symbolified_model )
        end
        substitute_uri( uri, object.instance_variable_get("@init_options").merge(opt) )
      end
      private :substituted_uri_for

      def http_do( method, url, data=nil )
        begin
          logger.debug "http_do: url: #{url}"
          keepalive = true
          if not @http
            keepalive = false
            @http = Net::HTTP.new(url.host, url.port)
            # FIXME: we should get the protocoll here instead of depending on the port for
            #         detecting SSL or not.
            if url.port == 443
               @http.use_ssl = true
            end
            @http.start
          end
          
          path = url.path
          if url.query
            path += "?" + url.query
          end
          logger.debug "http_do: path: #{path}"

          case method
          when /get/i
            @response = @http.get path, @http_header
          when /put/i
            raise "PUT without data" if data.nil?
            @response = @http.put path, data, @http_header
          when /post/i
            raise "POST without data" if data.nil?
            @response = @http.post path, data, @http_header
          when /delete/i
            @response = @http.delete path, @http_header
          else
            raise "unknown HTTP method: #{method.inspect}"
          end
        rescue Errno::EPIPE => err
          #keepalive connection died, cleanup and retry
          logger.debug "--> caught EPIPE, retrying with new HTTP connection"
          @http.finish
          @http = nil
          retry
        rescue SystemCallError => err
          raise ConnectionError, "Failed to establish connection: "+err.message
        end

        unless keepalive
          @http.finish
          @http = nil
        end

        return handle_response( @response )
      end
      private :http_do

      def handle_response( http_response )
        case http_response
        when Net::HTTPSuccess, Net::HTTPRedirection
          return http_response.read_body
        when Net::HTTPNotFound
          raise NotFoundError, http_response.read_body
        when Net::HTTPUnauthorized
          raise UnauthorizedError, http_response.read_body
        when Net::HTTPForbidden
          raise ForbiddenError, http_response.read_body
        when Net::HTTPClientError, Net::HTTPServerError
          raise Error, http_response.read_body
        end
        raise Error, http_response.read_body
      end
      private :handle_response
      
    end
  end
end

