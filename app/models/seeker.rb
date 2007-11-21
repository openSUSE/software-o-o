class Seeker < ActiveXML::Base
  def size
    data.children.length
  end

  def self.prepare_result(query, baseproject=nil)
    return SearchResult.search(query, baseproject)
  end

  class SearchResult < Array
    def self.search(query, baseproject)
      result = cache.searchresult(query, baseproject)
      return result unless result.nil?

      if query =~ / /
        xpath = query.split(" ").map {|part| "contains-ic(@name,'#{part}')"}.join(" and ")
      else
        xpath = "contains-ic(@name,'#{query}')"
      end

      if baseproject and not baseproject.empty?
        xpath = "("+xpath+")"
        xpath << " and path/project='#{baseproject}'"
      end
      bin = Seeker.find :binary, :match => xpath
      pat = Seeker.find :pattern, :match => xpath
      result = new(query)
      result.add_patlist(pat)
      result.add_binlist(bin)
      result.sort! {|x,y| y.relevance <=> x.relevance}


      cache.store_searchresult(query, baseproject, result)
      return result
    end

    def self.cache
      @cache ||= Cache.new
    end

    def inspect
      "<Seeker::Searchresult ##{object_id} @length=#{size}>"
    end

    def logger
      RAILS_DEFAULT_LOGGER
    end

    attr_reader :query
    attr_reader :binary_count
    attr_reader :pattern_count
    attr_accessor :page_length

    def initialize(query)
      @query = query
      @binary_count = 0
      @pattern_count = 0
      @page_length = 10
      super()
    end

    # page index starts with 1
    def page(idx)
      return [] if idx > page_count
      page = self[@page_length*(idx-1),@page_length]
      page.each do |item|
        item.update_description
      end
      return page
    end

    def page_count
      logger.debug "[SearchResult] calculating page_count: self.length: #{self.length}, @page_length: #@page_length"
      l = self.length or 1
      ((self.length-1)/@page_length)+1
    end

    def add_binlist(binlist)
      @index = Hash.new
      @binary_count = binlist.size
      binlist.each_binary do |bin|
        fragment = Fragment.new(bin)
        fragment.fragment_type = :binary
        add_fragment(fragment)
      end
    end

    def add_patlist(patlist)
      @index = Hash.new
      @pattern_count = patlist.size
      patlist.each_pattern do |pat|
        fragment = Fragment.new(pat)
        fragment.fragment_type = :pattern
        add_fragment(fragment)
      end
    end

    def add_fragment(fragment)
      key = fragment.__key
      if @index.has_key? key
        item = @index[key]
      else
        case fragment.fragment_type
        when :binary
          item = Binary.new(key, @query)
        when :pattern
          item = Pattern.new(key, @query)
        end
        @index[key] = item
        self << item
      end
      item.add_entry(fragment)
      return item
    end

    def dump
      out = "<ul>"
      each do |item|
        out << "<li>#{item.key} #{item.dump}</li>"
      end
      out << "</ul>"
    end

    class Item < Array
      attr_accessor :query
      attr_reader :key
      attr_reader :name
      attr_reader :project
      attr_reader :repository
      attr_reader :ymp_link
      attr_reader :description
      attr_reader :short_description
      attr_reader :relevance

      def initialize(key, query)
        @key = key
        @query = query
        @relevance = 0
      end

      def cache
        SearchResult.cache
      end

      def inspect
        "<#{self.class.name} ##{object_id} @length=#{size}>"
      end

      def add_entry(element)
        if element.__key != @key
          raise "key mismatch: #{element.__key} != #@key"
        end
        self << element
        cache_data(element) unless @data_cached
        calculate_relevance unless @relevance_calculated
      end

      def dump
        out = "<ul><li><b>Relevance:</b> #@relevance</li>"
        each do |bin|
          out << "<li>#{bin.filename} #{bin.dump}</li>"
        end
        out << "</ul>"
        return out
      end

      def update_description
        # implement in derived classes
      end
      
      private

      def cache_data(element)
        @project = element.project
        @repository = element.repository
        @name = element.name
        cache_specific_data(element)
        @data_cached = true
      end

      def cache_specific_data(element)
        # implement in derived classes
      end

      def calculate_relevance
        quoted_query = Regexp.quote @query
        @relevance_calculated = true
        @relevance += 15 if name =~/^#{quoted_query}$/i
        @relevance += 5 if project =~ /^#{quoted_query}$/i
        @relevance += 5 if name =~ /#{quoted_query}/i
        @relevance += 2 if project =~ /#{quoted_query}/i
        @relevance += 1 if project =~ /^openSUSE/i

        @relevance -= 10 if project =~ /^home:/
        
        calculate_specific_relevance
      end

      def calculate_specific_relevance
        # implement in derived classes
      end
    end

    class Binary < Item
      attr_reader :arch_hash
      attr_reader :filename
      attr_reader :arch

      def initialize(key, query)
        super(key, query)
        @arch_hash = Hash.new
      end

      def cache_specific_data(element)
        @filename = element.filename
        @arch = element.arch
      end
      
      def calculate_specific_relevance
        @relevance -= 10 if name =~ /-debuginfo$/
        @relevance -= 3 if name =~ /-devel$/
        @relevance -= 3 if name =~ /-doc$/
      end

      def update_description
        @description = cache.description(self)
        return unless @description.nil?
        return if self.empty?
        begin
          bin = self[0]
          info = ::Published.find bin.filename, :view => "fileinfo", :project => @project,
            :repository => @repository, :arch => bin.arch.to_s
          if info.has_element? :description
            @description = info.description.to_s
          else
            @description = ""
          end
        rescue ActiveXML::Transport::NotFoundError
        rescue RuntimeError
          @description = ""
        end
        cache.store_description(self, @description)
        return @description
      end
    end

    class Pattern < Item
      attr_reader :filename
      attr_reader :filepath
      attr_reader :repository
      attr_reader :type

      def calculate_specific_relevance
        # pattern bonus
        @relevance += 20
      end
      
      def cache_specific_data(element)
        @filename = element.filename.to_s
        @filepath = element.filepath.to_s
        @repository = element.repository.to_s
        @type = element.type.to_s
      end

      def update_description
        @description = cache.description(self)
        return unless @description.nil?
        patfname = @filename.split(/.#@type$/)[0]
        begin
          pat = ::Published.find @filename, :project => @project, :repository => @repository, :view => :fileinfo
          if pat.has_element? :description
            @description = pat.description.to_s
          else
            @description = ""
          end
        rescue ActiveXML::Transport::NotFoundError
        end
        cache.store_description(self, @description)
        return @description
      end
    end

    class Fragment < Hash
      attr_accessor :fragment_type

      def initialize(element)
        #XXX: xml-backend specific code, change when xml-backends are
        #XXX: switchable
        element.data.attributes.each do |attr|
          self[attr.name] = attr.value
        end
      end

      def __key
        @__key ||= @fragment_type.to_s+"|"+%w(project repository name).map{|x| self[x]}.join('|')
      end

      def dump
        out = "<ul>"
        each do |key,val|
          out << "<li><b>#{key}:</b> #{val}</li>x"
        end
        out << "</ul>"
        return out
      end

      def type(*args)
        method_missing(:type,*args)
      end

      def method_missing(symbol,*args,&block)
        if self.has_key? symbol.to_s
          return self[symbol.to_s]
        end
        super(symbol,*args,&block)
      end
    end

    class Cache
      attr_accessor :active
      def initialize
        tmpdir = RAILS_ROOT+"/tmp/cache"
        @desctmpdir = tmpdir+"/_descriptions"
        @resulttmpdir = tmpdir+"/_searchresults"
        @descexpire = 600.0
        @resultexpire = 300.0
        @active = true
      end

      def logger
        RAILS_DEFAULT_LOGGER
      end

      def description(item)
        fname = @desctmpdir+"/"+item.key
        return read(fname, @descexpire)
      end

      def searchresult(query, baseproject)
        fname = @resulttmpdir+"/"+query+"|"+baseproject.to_s
        if str = read(fname, @resultexpire)
          return Marshal.load(str)
        else
          return nil
        end
      end

      def store_description(item, desc)
        fname = @desctmpdir+"/"+item.key
        write(fname, desc)
      end

      def store_searchresult(query, baseproject, result)
        fname = @resulttmpdir+"/"+query+"|"+baseproject.to_s
        write(fname, Marshal.dump(result))
      end

      private
      def read(fname, exp_time_sec)
        return nil unless @active
        begin
          stat = File::stat(fname)
        rescue Errno::ENOENT
          return nil
        end

        if (Time.now-stat.mtime) < exp_time_sec
          logger.debug "[Seeker::SearchResult::Cache] reading #{fname} from cache"
          return File.read(fname)
        else
          return nil
        end
      end

      def write(fname, data)
        return unless @active
        File.open(fname,"w") do |f|
          logger.debug "[Seeker::SearchResult::Cache] writing #{fname} to cache"
          f.write data
        end
      end
    end
  end
end
