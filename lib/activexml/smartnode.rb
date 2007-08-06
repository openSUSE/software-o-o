require 'xml/smart'

module ActiveXML
  class SmartNode
    class << self

      def setup
        @@logger = ActiveXML::Config.logger
      end

      def get_class(element_name)
        # FIXME: lines below don't work with relations. the related model has to
        # be pulled in when the relation is defined
        # 
        # axbase_subclasses = ActiveXML::Base.subclasses.map {|sc| sc.downcase}
        # if axbase_subclasses.include?( element_name )
        
        if %w{package project result person platform}.include?( element_name ) && Object.const_defined?( element_name.capitalize )
          return Object.const_get( element_name.capitalize )
        end
        return ActiveXML::SmartNode
      end

      def namespace(ns=nil)
        return @namespace unless ns
        @namespace = ns
      end

      #creates an empty xml document
      # FIXME: works only for projects/packages, or by overwriting it in the model definition
      # FIXME: could get info somehow from schema, as soon as schema evaluation is built in
      def make_stub(opt)
        logger.debug "--> creating stub element for #{self.name}, arguments: #{opt.inspect}"
        if opt.nil?
          raise CreationError, "Tried to create document without opt parameter"
        end
        root_name = self.name.downcase
        doc = XML::Smart.string("<#{root_name}/>")
        root = doc.root
        root.attributes.add 'name', opt[:name]
        root.attributes.add 'created', opt[:created_at] if opt[:created_at]
        root.attributes.add 'updated', opt[:updated_at] if opt[:updated_at]
        root.add "title"
        root.add "description"

        root
      end

      def logger
        ActiveXML::Config.logger
      end
    end

    #instance methods

    attr_reader :data
    attr_accessor :throw_on_method_missing
    
    def initialize( data )
      if data.kind_of? XML::Smart::Dom::Element
        @data = data
      elsif data.kind_of? String
        self.raw_data = data
      elsif data.kind_of? Hash
        #create new
        @data = self.class.make_stub(data)
      else
        raise "constructor needs either REXML::Element, String or Hash"
      end

      @throw_on_method_missing = true
      @node_cache = {}
    end

    def raw_data=( data )
      if data.kind_of? XML::Smart::Dom::Element
        @data = data.clone
      else
        if ActiveXML::Config.lazy_evaluation
          @raw_data = data.clone
        else
          @data = XML::Smart.string(data.to_str).root
        end
      end
    end

    def element_name
      data.name
    end

    def data
      #return @data unless @data.nil?
      @data ||= XML::Smart.string(@raw_data.to_str).root
    end

    def define_iterator_for_element( elem )
      logger.debug "2> starting to define iterator for element '#{elem}'"

      eval <<-end_eval
      def each_#{elem}
        return nil if not has_element? '#{elem}'
        result = Array.new
        data.find('#{elem}').each do |e|
          result << node = create_node_with_relations(e)
          yield node if block_given?
        end
        result
      end
      end_eval
    end
    #private :define_iterator_for_element


    def each
      result = Array.new
      data.children.each do |e|
        result << node = create_node_with_relations(e)
        yield node if block_given?
      end
      return result
    end


    def logger
      self.class.logger
    end

    def to_s
      data.children.entries.select {|x| x.kind_of? XML::Smart::Dom::Text}.to_s
    end

    def dump_xml
      if @data.nil?
        @raw_data
      else
        data.dump
      end
    end

    def to_param
      data.attributes['name']
    end

    #tests if a child element exists matching the given query.
    #query can either be an element name, an xpath, or any object
    #whose to_s method evaluates to an element name or xpath
    def has_element?( query )
      not data.find(query.to_s).empty?
    end

    def has_attribute?( query )
      data.attributes.has_attr? query
    end

    #FIXME: not migrated to XML::Smart
    #removes all elements after the last named from @data and return in list
    def split_data_after( element_name )
      return false if not element_name

      element_name = element_name.to_s

      state = :before_element
      elem_cache = []
      data.each_element do |elem|
        case state
        when :before_element
          next if elem.name != element_name
          state = :element
          redo
        when :element
          next if elem.name == element_name
          state = :after_element
          redo
        when :after_element
          elem_cache << elem
          data.delete_element elem
        end
      end

      elem_cache
    end

    #FIXME: not migrated to XML::Smart
    def merge_data( elem_list )
      elem_list.each do |elem|
        data.add_element elem
      end
    end


    def create_node_with_relations( element )
      #FIXME: relation stuff should be taken into an extra module
      klass = self.class.get_class(element.name)
      opt = {}
      node = nil
      node ||= klass.new(element)
      #logger.debug "created node: #{node.inspect}"
      return node
    end

    def xml_find_args(xpath)
      ns = self.class.namespace
      return xpath unless ns
      return "x:"+xpath, {"x" => ns}
    end

    def method_missing( symbol, *args, &block )
      #logger.debug "called method: #{symbol}(#{args.map do |a| a.inspect end.join ', '})"
      ns = self.class.namespace

      if( data.attributes.has_attr? symbol.to_s )
        return data.attributes[symbol.to_s]
      end

      if( symbol.to_s =~ /^each_(.*)$/ )
        elem = $1
        return [] if not has_element? elem
        result = Array.new
        data.find(*xml_find_args(elem)).each do |e|
          result << node = create_node_with_relations(e)
          block.call(node) if block
        end
        return result
      end

      if( not data.find(*xml_find_args(symbol.to_s)).empty? )
        xpath = args.shift
        query = xpath ? "#{symbol}[#{xpath}]" : symbol.to_s
        #logger.debug "method_missing: query is '#{query}'"
        if @node_cache[query]
          node = @node_cache[query]
          #logger.debug "taking from cache: #{node.inspect.to_s.slice(0..100)}"
        else
          e = data.find(*xml_find_args(query))
          return nil if e.length == 0

          node = create_node_with_relations(e[0])
          
          @node_cache[query] = node
        end
        return node
      end
      
      return unless @throw_on_method_missing
      super( symbol, *args )
    end
  end
end
