class SearchController < ApplicationController
  layout "application"

  def index
    if params[:lang].nil?
      lang = request.compatible_language_from(LANGUAGES) || "en"
    else
      lang = params[:lang][0]
    end
    @lang = lang
    GetText.locale = lang

    if params[:baseproject]
      @baseproject = params[:baseproject]
    end
    if params[:q]
      perform_search
    end
  end

  def search
    if perform_search
      render :partial => "search_result" if request.xhr?
      render "_search_result" if !request.xhr?
    else
      render :text => "Search strings must have at least 2 characters."
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

    return false if @query.length < 2
    return false if @query =~ / / and @query.split(" ").select{|e| e.length < 2 }.size > 0

    base = @baseproject=="ALL" ? "" : @baseproject
    @result = Seeker.prepare_result(CGI.escape(@query).gsub("+", " "), base)
    if @current_page == 1 and @result.length > 1 # ignore sub pages
      SearchHistory.create :query => @query, :base => @baseproject, :patterns => @result.pattern_count, 
                           :binaries => @result.binary_count, :count => @result.length
    end
    return true
  end
end
