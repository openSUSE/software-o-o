class SearchController < OBSController
  before_action :set_search_options
  before_action :prepare_appdata

  def index
    base = @baseproject == "ALL" ? "" : @baseproject

    # if we have a baseproject, and don't show unsupported packages, shortcut: '
    if @baseproject.present? && @baseproject != "ALL" && !@search_unsupported && !@search_project
      @search_project = @baseproject
    end

    begin
      query_opts = { baseproject: base,
                     project: @search_project,
                     exclude_filter: @exclude_filter,
                     exclude_debug: @exclude_debug }
      @packages = OBS.search_published_binary(@search_term, query_opts)
    rescue Faraday::ClientError => e
      raise unless e.response[:status] == 413 # Payload Too Large

      logger.debug("Too many hits, trying exact match for: #{@search_term}")
      @search_term = @search_term.split(" ").map { |x| "\"#{CGI.escape(x)}\"" }.join(" ")
      @packages = OBS.search_published_binary(@search_term, query_opts)
    rescue OBS::InvalidSearchTerm => e
      flash[:error] = e.message
      render 'find' and return
    end

    filter_packages

    # sort by package name length
    @packages.sort! { |a, b| a.name.length <=> b.name.length }
    # show official package first
    @packages.sort! { |a, b| helpers.trust_level(b, base) - helpers.trust_level(a, base) }

    @packagenames = @packages.map { |p| p.name }

    # mix in searchresults from appdata, as the api can't search in summary and description atm
    if !@search_project
      appdata_hits = @appdata[:apps].select do |a|
        (a[:summary].match(/#{Regexp.quote(@search_term)}/i) ||
          a[:name].match(/#{Regexp.quote(@search_term)}/i))
      end
      @packagenames += appdata_hits.map { |a| a[:pkgname] }
    end
    @packagenames = @packagenames.uniq

    if @packagenames.size == 1
      redirect_to(:controller => :package, :action => :show, :package => @packagenames.first, :search_term => @search_term) and return
    elsif request.xhr?
      render :partial => 'find_results' and return
    else
      render 'find' and return
    end
  end

  def find; end
end
