module ActiveXML
  class GeneralError < StandardError; end
  class NotFoundError < GeneralError; end
  class CreationError < GeneralError; end

  class Base < LibXMLNode

    include ActiveXML::Config

    @default_find_parameter = :name

    class << self #class methods

      #transport object, gets defined according to configuration when Base is subclassed
      attr_reader :transport
      
      def inherited( subclass )
        # called when a subclass is defined
        #logger.debug "Initializing ActiveXML model #{subclass}"
        subclass.instance_variable_set "@default_find_parameter", @default_find_parameter
      end
      private :inherited

      # setup the default parameter for find calls. If the first parameter to <Model>.find is a string,
      # the value of this string is used as value f
      def default_find_parameter( sym )
        @default_find_parameter = sym
      end

      def setup(transport_object)
        super()
        @@transport = transport_object
        logger.debug "--> ActiveXML successfully set up"
        true
      end

      def belongs_to(*tag_list)
        logger.debug "#{self.name} belongs_to #{tag_list.inspect}"
        @rel_belongs_to ||= Array.new
        @rel_belongs_to.concat(tag_list).uniq!
      end

      def has_many(*tag_list)
        #logger.debug "#{self.name} has_many #{tag_list.inspect}"
        @rel_has_many ||= Array.new
        @rel_has_many.concat(tag_list).uniq!
      end

      def error
        @error
      end

      def find( *args )
        #FIXME: needs cleanup
        #TODO: factor out xml stuff to ActiveXML::Node
        #logger.debug "#{self.name}.find( #{args.map {|a| a.inspect}.join(', ')} )"

        args[1] ||= {}
        opt = args[0].kind_of?(Hash) ? args[0] : args[1]
        opt[@default_find_parameter] = args[0] if( args[0].kind_of? String )

        #logger.debug "prepared find args: #{args.inspect}"

        #TODO: somehow we need to set the transport again, as it was not set when subclassing.
        # only happens with rails >= 2.3.4 and config.cache_classes = true
        transport = config.transport_for(self.name.downcase.to_sym)
        raise "No transport defined for model #{self.name}" unless transport
        transport.find( self, *args )
      end

      def find_cached( *args )
        cache_key = self.name + '-' + args.to_s
        if !(results = Rails.cache.read(cache_key))
          results = find( *args )
          Rails.cache.write(cache_key, results, :expires_in => 30.minutes) if results
        end
      results
      end

      def free_cache( *args )
        cache_key = self.name + '-' + args.to_s
        Rails.cache.delete(cache_key)
      end

    end #class methods

    def initialize( data, opt={} )
      super(data)
      opt = data if data.kind_of? Hash and opt.empty?
      @init_options = opt
    end

    def name
      method_missing( :name )
    end


    def save(opt={})
      logger.debug "Save #{self.class}"
      logger.debug "XML #{data}"
      transport = TransportMap.transport_for(self.class.name.downcase.to_sym)
      transport.save self, opt
      return true
    end

    def delete(opt={})
      logger.debug "Delete #{self.class}, opt: #{opt.inspect}"
      transport = TransportMap.transport_for(self.class.name.downcase.to_sym)
      transport.delete self, opt
      return true
    end
  end
end
