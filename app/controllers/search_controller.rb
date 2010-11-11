class SearchController < ApplicationController

  def index
    @exclude_debug = true
    @exclude_filter = 'home:'
    if params[:baseproject]
      @baseproject = params[:baseproject]
    end
    if params[:q]
      perform_search
    end
  end

  def download
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :file => params[:file]
    redirect_to "http://download.opensuse.org/repositories/" + params[:file]
  end

  private

  def perform_search
    @query = params[:q]
    @baseproject = params[:baseproject]
    @current_page = params[:p].to_i
    @current_page = 1 if @current_page == 0
    @exclude_debug = params[:exclude_debug]
    @exclude_filter = params[:exclude_filter]
    @project = params[:project]

    if @query.split(" ").select{|e| e.length < 2 }.size > 0
      flash.now[:error] = _("Please use search strings of at least 2 characters") and return
    end

    base = @baseproject=="ALL" ? "" : @baseproject
    begin
      @result = Seeker.prepare_result(CGI.escape(@query).gsub("+", " "), base, @project, @exclude_filter, @exclude_debug)
      if @current_page == 1 and @result.length > 1 # ignore sub pages
        SearchHistory.create :query => @query, :base => @baseproject, :patterns => @result.pattern_count,
          :binaries => @result.binary_count, :count => @result.length
      end
    rescue => e
      search_error, code, api_exception = ActiveXML::Transport.extract_error_message e
      if code == "413"
        @result = Seeker.prepare_result(CGI.escape("\"#{@query}\"").gsub("+", " "), base, @project, @exclude_filter, @exclude_debug)
        unless @result.blank?
          flash.now[:note] = _("Switched to exact match due to too many hits on substring search.")
        else
          flash.now[:error] = _("Please be more precise in your search, search limit reached.")
        end
      else
        logger.error _("Could not perform search: ") + search_error
        flash.now[:error] = _("Could not perform search: ") + search_error
      end
      return
    end

    flash.now[:warn] = _("Please be more precise in your search, search limit reached.") if @result.binary_count >= 1000
    return true
  end

end
