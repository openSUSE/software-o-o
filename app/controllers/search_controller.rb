class SearchController < ApplicationController

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
    begin
      @result = Seeker.prepare_result(CGI.escape(@query).gsub("+", " "), base)
      if @current_page == 1 and @result.length > 1 # ignore sub pages
        SearchHistory.create :query => @query, :base => @baseproject, :patterns => @result.pattern_count,
          :binaries => @result.binary_count, :count => @result.length
      end
    rescue => e
      @search_error, code, api_exception = ActiveXML::Transport.extract_error_message e
      logger.error "Cannot perform search: #{@search_error}"
    end
    return true
  end

end
