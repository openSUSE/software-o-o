class SearchController < ApplicationController
  before_action :set_search_options
  before_action :prepare_appdata

  def index
    render 'find' and return if @search_term.blank?

    base = (@baseproject == "ALL") ? "" : @baseproject

    #if we have a baseproject, and don't show unsupported packages, shortcut: '
    if !@baseproject.blank? && @baseproject != "ALL" && !@search_unsupported && !@search_project
      @search_project = @baseproject
    end

    begin
      @packages = Seeker.prepare_result("#{@search_term}", base, @search_project, @exclude_filter, @exclude_debug)
    rescue ActiveXML::Transport::Error => e
      if e.code.to_s == "413"
        logger.debug("Too many hits, trying exact match for: #{@search_term}")
        @search_term = @search_term.split(" ").map { |x| "\"#{CGI.escape(x)}\"" }.join(" ")
        @packages = Seeker.prepare_result("#{@search_term}", base, @search_project, @exclude_filter, @exclude_debug)
      end
      raise e if @packages.nil?
    end

    filter_packages

    # sort by package name length
    @packages.sort! { |a, b| a.name.length <=> b.name.length }
    # show official package first
    @packages.sort! { |a, b| trust_level(b, base) - trust_level(a, base) }

    @packagenames = @packages.map { |p| p.name }

    # mix in searchresults from appdata, as the api can't search in summary and description atm
    if (!@search_project)
      appdata_hits = @appdata[:apps].select { |a| (a[:summary].match(/#{Regexp.quote(@search_term)}/i) ||
          a[:name].match(/#{Regexp.quote(@search_term)}/i)) }.map { |a| a[:pkgname] }
      @packagenames = (@packagenames + appdata_hits)
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

  def trust_level(package, project)
    # 3: official package
    # 2: official package in Factory
    # 1: experimental package
    # 0: community package
    if package.project == project || package.project == "#{project}:Update" || package.project == "#{project}:NonFree"
      3
    elsif package.project == "openSUSE:Factory"
      2
    elsif (package.project.start_with?('home'))
      0
    else
      1
    end
  end
end
