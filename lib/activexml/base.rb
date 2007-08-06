require 'activexml/node'
#require 'opensuse/frontend'

module ActiveXML
  class GeneralError < StandardError; end
  class NotFoundError < GeneralError; end
  class CreationError < GeneralError; end

  class Base < Node
    @default_find_parameter = :name

    class << self #class methods

      #transport object, gets defined according to configuration when Base is subclassed
      attr_reader :transport
      
      def inherited( subclass )
        # called when a subclass is defined
        logger.debug "initializing model #{subclass}"

        # setup transport object for this model
        subclass.instance_variable_set "@transport", config.transport_for(subclass.name.downcase.to_sym)
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
        logger.debug "belongs_to #{tag_list.inspect}"
        @rel_belongs_to ||= Array.new
        @rel_belongs_to.concat(tag_list).uniq!
      end

      def has_many(*tag_list)
        logger.debug "has_many #{tag_list.inspect}"
        @rel_has_many ||= Array.new
        @rel_has_many.concat(tag_list).uniq!
      end

      def error
        @error
      end

      def find( *args )
        #FIXME: needs cleanup
        #TODO: factor out xml stuff to ActiveXML::Node
        logger.debug "#{self.name}.find( #{args.map {|a| a.inspect}.join(', ')} )"

        args[1] ||= {}
        opt = args[0].kind_of?(Hash) ? args[0] : args[1]
        opt[@default_find_parameter] = args[0] if( args[0].kind_of? String )

        logger.debug "prepared find args: #{args.inspect}"
        
        raise "No transport defined for model #{self.name}" unless transport
        transport.find( self, *args )
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

    def save
      logger.debug "Save #{self.class}"
      logger.debug "XML #{data}"
      put_opt = {}
     
      self.class.transport.save self
      return true
    end
  end
end
