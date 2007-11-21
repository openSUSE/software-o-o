class SearchController < ApplicationController
  def index
    if params[:baseproject]
      @baseproject = params[:baseproject]

      # this can get removed, when 11.0 is released and available in OBS
      if @baseproject == "openSUSE:11.0"
         @baseproject = "openSUSE:Factory"
      end

    end
    if params[:q]
      perform_search
    end
  end

  def search
    if perform_search
      render :partial => "search_result"
    else
      render :text => "Search string must have at least 2 characters."
    end
  end

  def update_description
    @item_key = params[:item_key]
    if params[:type] == :pattern
      render :update do |page|
        page.replace_html "description-#@item_key", "blub"
      end
      return
    end
    @fname = params[:fname]
    @item_description = "pre"
    tmp, @project, @repository = @item_key.split(/\//)
    begin
      info = ::Published.find @fname, :view => "fileinfo", :project => @project,
        :repository => @repository, :arch => params[:arch]
      @item_description = info.description.to_s
    rescue ActiveXML::Transport::NotFoundError
    rescue RuntimeError
    end
    render :update do |page|
      page.replace_html "description-#@item_key", :partial => 'description'
    end
  end

  private
  def perform_search
    @query = params[:q]
    @baseproject = params[:baseproject]
    @current_page = params[:p].to_i
    @current_page = 1 if @current_page == 0

    if @query =~ / /
      #sort by length DESC then alphabetically ASC
      parts = @query.split(" ").sort_by{|a| [-(a.size),a]}
      return false if parts[0].length < 2
      @query = parts.join(" ") 
    else
      return false if @query.length < 2
    end

    base = @baseproject=="ALL" ? "" : @baseproject
    @result = Seeker.prepare_result(@query, base)
    return true
  end 
end
