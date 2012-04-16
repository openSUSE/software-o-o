class SearchController < ApplicationController

  before_filter :set_search_options, :only => [:find, :searchresult]
  before_filter :prepare_appdata, :only => [:find, :searchresult]

  def searchresult
    render 'find' and return if @search_term.blank?

    base = ( @baseproject == "ALL" ) ? "" : @baseproject
    #FIXME: remove @search_unsupported when redesigning search options
    @search_unsupported = true

    #if we have a baseproject, and don't show unsupported packages, shortcut: '
    if !@baseproject.blank? && !( @baseproject == "ALL" ) && !@search_unsupported && !@search_project
      @search_project = @baseproject
    end

    begin 
      @packages = Seeker.prepare_result("#{@search_term}", base, @search_project, @exclude_filter, @exclude_debug)
      SearchHistory.create :query => @search_term, :count => @packages.size
    rescue => e
      search_error, code, api_exception = ActiveXML::Transport.extract_error_message e
      if code == "413"
        logger.debug("Too many hits, trying exact match for: #{@search_term}")
        SearchHistory.create :query => @search_term, :count => 0
        @search_term = @search_term.split(" ").map{|x| "\"#{CGI.escape(x)}\""}.join(" ")
        @packages = Seeker.prepare_result("#{@search_term}", base, @search_project, @exclude_filter, @exclude_debug)
      end
      raise e if @packages.nil?
    end

    # filter out devel projects on user setting
    unless (@search_unsupported || @search_project)
      @packages = @packages.select{|p| (@distributions.map{|d| d[:project]}.include? p.project) ||
          @distributions.map{|d| "#{d[:project]}:Update"}.include?( p.project ) || @distributions.map{|d| "#{d[:project]}:NonFree"}.include?( p.project ) }
    end

    # only show packages
    @packages = @packages.select{|p| p.first.type != 'ymp'}
    @packagenames = @packages.map{|p| p.name}

    #mix in searchresults from appdata, as the api can't search in summary and description atm
    if (!@search_project)
    appdata_hits = @appdata[:apps].select{|a| ( a[:summary].match(/#{@search_term}/i) ||
          a[:name].match(/#{@search_term}/i) ) }.map{|a| a[:pkgname]}
    @packagenames = (@packagenames + appdata_hits)
    end
    @packagenames = @packagenames.uniq.sort_by {|x| x.length}

    if @packagenames.size == 1
      redirect_to( :controller => :package, :action => :show, :package => @packagenames.first, :search_term => @search_term ) and return
    elsif request.xhr?
      render :partial => 'find_results' and return
    else
      render 'find' and return
    end
  end


end
