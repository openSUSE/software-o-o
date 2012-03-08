require 'md5'

class Seeker < ActiveXML::Base

  def self.prepare_result(query, baseproject=nil, project=nil, exclude_filter=nil, exclude_debug=false)
    cache_key = query
    cache_key += "_#{baseproject}" if baseproject
    cache_key += "_#{exclude_filter}" if exclude_filter
    cache_key += "_#{exclude_debug}" if exclude_debug
    cache_key += "_#{project}" if project
    cache_key = 'searchresult_' + MD5::md5( cache_key ).to_s
    Rails.cache.fetch(cache_key, :expires_in => 60.minutes) do
      SearchResult.search(query, baseproject, project, exclude_filter, exclude_debug)
    end
  end


  class SearchResult < Array
    def self.search(query, baseproject, project=nil, exclude_filter=nil, exclude_debug=false)
      words = query.split(" ").select {|part| !part.match(/^[0-9_\.-]+$/) }
      versrel = query.split(" ").select {|part| part.match(/^[0-9_\.-]+$/) }
      logger.debug "splitted words and versrel: #{words.inspect} #{versrel.inspect}"
      raise "Please provide a valid search term" if words.blank?

      xpath = "contains-ic(@name, " + words.select{|word| 
        !word.match(/^".+"$/) }.map{|word| "'#{word.gsub(/['"()]/, "")}'"}.join(", ") + ")"
      words.select{|word| word.match(/^".+"$/) }.map{|word| word.gsub( "\"", "" ) }.each do |word|
        xpath = "@name = '#{word.gsub(/['"()]/, "")}' "
      end
      xpath += ' and ' + versrel.map {|part| "starts-with(@versrel,'#{part}')"}.join(" and ") unless versrel.blank?
      xpath += " and path/project='#{baseproject}'" unless baseproject.blank?
      xpath += " and @project = '#{project}' " unless project.blank?
      xpath += " and not(contains-ic(@name, '-debuginfo')) and not(contains-ic(@name, '-debugsource'))" if exclude_debug
      xpath += " and not(contains-ic(@project, '#{exclude_filter}'))" unless exclude_filter.blank?

      bin = Seeker.find :binary, :match => xpath
      pat = Seeker.find :pattern, :match => xpath
      raise "Backend not responding" if( bin == nil && pat == nil )

      result = new(query)
      result.add_patlist(pat)
      result.add_binlist(bin)

      # remove this hack when the backend can filter for project names
      result.reject!{|res| /#{exclude_filter}/.match( res.project ) } unless exclude_filter.blank?
      result.sort! {|x,y| y.relevance <=> x.relevance}
      return result
    end

    def inspect
      "<Seeker::Searchresult ##{object_id} @length=#{size}>"
    end

    def self.logger
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
        item.description
      end
      return page
    end

    def page_count
      ((self.length-1)/@page_length)+1
    end

    def add_binlist(binlist)
      @index = Hash.new
      @binary_count = 0
      binlist.each_binary do |bin|
        @binary_count += 1
        fragment = Fragment.new(bin)
        fragment.fragment_type = :binary
        add_fragment(fragment)
      end
    end

    def add_patlist(patlist)
      @index = Hash.new
      @pattern_count = 0
      patlist.each_pattern do |pat|
        @pattern_count += 1
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
      attr_reader :baseproject

      def initialize(key, query)
        @key = key
        @query = query
        @relevance = 0
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

      def description
        # implement in derived classes
      end

      def logger
        RAILS_DEFAULT_LOGGER
      end
      
      private

      def cache_data(element)
        @project = element.project
        @repository = element.repository
        @name = element.name
        @baseproject = element.baseproject
        @version = element.version
        @release = element.release
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
        @relevance += 5 if name =~/^#{quoted_query}/i
        @relevance += 15 if project =~ /^openSUSE:/i
        @relevance += 5 if project =~ /^#{quoted_query}$/i
        @relevance += 2 if project =~ /^#{quoted_query}/i
        @relevance -= 5 if project =~ /unstable/i
        @relevance -= 10 if project =~ /^home:/
        @relevance -= 20 if project =~ /^openSUSE:Maintenance/i
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
      attr_reader :version
      attr_reader :release
      attr_reader :description
      attr_reader :summary
      attr_reader :size
      attr_reader :mtime
      attr_reader :requires
      attr_reader :provides

      def initialize(key, query)
        super(key, query)
        @arch_hash = Hash.new
      end

      def cache_specific_data(element)
        @filename = element.filename
        @arch = element.arch
      end

      def load_extra_data
        unless @description
          @description = ""
          bin = self[0]
          begin
            info = ::Published.find_cached bin.filename, :view => :fileinfo, :project => @project,
              :repository => @repository, :arch => bin.arch.to_s, :expires_in => 6.hour
          rescue => e
            logger.error "Error fetching info for binary: #{e.message}"
          end
          if info
            @description = info.description.to_s if info.has_element? :description
            @summary = info.summary.to_s if info.has_element? :summary
            @size = info.size.to_s if info.has_element? :size
            @mtime = info.mtime.to_s if info.has_element? :mtime
            @requires = info.each_requires.map{|r| r.text} if info.has_element? :requires
            @provides = info.each_provides.map{|r| r.text} if info.has_element? :provides
          end
        end
      end

      def calculate_specific_relevance
        @relevance -= 10 if name =~ /-debugsource$/
        @relevance -= 10 if name =~ /-debuginfo$/
        @relevance -= 3 if name =~ /-devel$/
        @relevance -= 3 if name =~ /-doc$/
      end

      def description
        load_extra_data
        @description
      end

      def summary
        load_extra_data
        @summary
      end

      def requires
        load_extra_data
        @requires
      end

      def provides
        load_extra_data
        @provides
      end

      def mtime
        load_extra_data
        @mtime
      end

      def size
        load_extra_data
        @size
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

      def description
        cache_key = "desc_pat_" + @filename + "_" + @project + "_" + @repository
        Rails.cache.fetch(cache_key, :expires_in => 6.hours) do
          @description = ""
          begin
            pat = ::Published.find @filename, :project => @project, :repository => @repository, :view => :fileinfo
            @description = pat.description.to_s if pat.has_element? :description
          rescue
          end
          @description
        end
      end

    end

    class Fragment < Hash
      attr_accessor :fragment_type

      def initialize(element)
        %w(project repository name filename filepath arch type baseproject type version release).each do |att|
          self[att] = element.value att
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

  end
end
