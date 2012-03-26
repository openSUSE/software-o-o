class SearchController < ApplicationController

  before_filter :set_beta_warning, :only => [:find, :searchresult]
  before_filter :set_search_options, :only => [:find, :searchresult]
  before_filter :prepare_appdata, :only => [:find, :searchresult]

  def index
    @exclude_debug = true
    @include_home = 'false'
    if params[:baseproject]
      @baseproject = params[:baseproject]
    end
    if params[:q]
      perform_search
      set_default_message
    end
  end

  def download
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :file => params[:file]
    redirect_to "http://download.opensuse.org/repositories/" + params[:file]
  end


  def searchresult
    base = @baseproject=="ALL" ? "" : @baseproject    
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
    unless @search_unsupported
      @packages = @packages.select{|p| (@distributions.map{|d| d[:project]}.include? p.project) ||
          @distributions.map{|d| "#{d[:project]}:Update"}.include?( p.project ) || @distributions.map{|d| "#{d[:project]}:NonFree"}.include?( p.project ) }
    end

    # only show hits for our base distributions right now
    @packages = @packages.select{|p| @distributions.map{|d| d[:project]}.include?( p.baseproject ) }
    # only show rpms
    @packages = @packages.select{|p| p.first.type == 'rpm'}
    @packagenames = @packages.map{|p| p.name}

    #mix in searchresults from appdata, as the api can't search in summary and description atm
    appdata_hits = @appdata[:apps].select{|a| a[:summary].match(/#{@search_term}/i)}.map{|a| a[:pkgname]}
    @packagenames = (@packagenames + appdata_hits).uniq.sort_by {|x| x.length}

    if request.xhr?
      render :partial => 'find_results' and return
    else
      render 'find'
    end
  end


  private

  def perform_search
    @query = params[:q]
    @baseproject = params[:baseproject]
    @current_page = params[:p].to_i
    @current_page = 1 if @current_page == 0

    @exclude_debug = params[:exclude_debug]
    @include_home = params[:include_home]
    exclude_filter = 'home:' if params[:include_home].nil?

    @project = params[:project]

    if @query.split(" ").select{|e| e.length < 2 }.size > 0
      flash.now[:error] = _("Please use search strings of at least 2 characters") and return
    end

    base = @baseproject=="ALL" ? "" : @baseproject
    begin
      @result = Seeker.prepare_result(@query, base, @project, exclude_filter, @exclude_debug)
      if @current_page == 1 # ignore sub pages
        SearchHistory.create :query => @query, :base => @baseproject, :patterns => @result.pattern_count,
          :binaries => @result.binary_count, :count => @result.length
      end
    rescue => e
      search_error, code, api_exception = ActiveXML::Transport.extract_error_message e
      if code == "413"
        logger.debug("Too many hits, trying exact match for: #{@query}")
        @query = @query.split(" ").map{|x| "\"#{CGI.escape(x)}\""}.join(" ")
        @result = Seeker.prepare_result(@query, base, @project, exclude_filter, @exclude_debug)
        unless @result.blank?
          flash.now[:note] = _("Switched to exact match due to too many hits on substring search.")
        else
          flash.now[:error] = _("Please be more precise in your search, search limit reached.")
        end
      else
        logger.error "Could not perform search: " + search_error + e.to_s
        flash.now[:error] = _("Could not perform search: ") + search_error
      end
      return
    end

    flash.now[:warn] = _("Please be more precise in your search, search limit reached.") if @result.binary_count >= 1000
    return true
  end


  def set_default_message
    if DEFAULT_SEARCHES[params[:q]]
      flash.now[:note] = DEFAULT_SEARCHES[params[:q]]
    end
  end

end
