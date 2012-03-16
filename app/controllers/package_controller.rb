class PackageController < ApplicationController

  before_filter :set_beta_warning
  before_filter :set_search_options, :only => [:show]

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname

    @search_term = params[:search_term]
    @base_appdata_project = "openSUSE:Factory"

    @packages = Seeker.prepare_result("\"#{@pkgname}\"", nil, nil, nil, nil)
    # only show rpms
    @packages = @packages.select{|p| p.first.type == 'rpm'}
    @default_project = @baseproject || @template.default_baseproject
    @default_project_name = @distributions.select{|d| d[:project] == @default_project}.first[:name]
    @default_repo = @distributions.select{|d| d[:project] == @default_project}.first[:repository]
    if (@packages.select{|s| s.project == "#{@default_project}:Update"}.size >0)
      @default_package = @packages.select{|s| s.project == "#{@default_project}:Update"}.first
    elsif (@packages.select{|s| s.project == "#{@default_project}:NonFree"}.size >0)
      @default_package = @packages.select{|s| s.project == "#{@default_project}:NonFree"}.first
    else
      @default_package = @packages.select{|s| s.project == (@default_project)}.first
    end

    # Fetch appstream data for app (TODO: needs src package name, not provided by obs for released products)
    appdata = Appdata.find_cached :prj => @base_appdata_project, :repo => @default_repo, :arch => "i586",
      :pkgname => @pkgname, :appdata => "#{@pkgname}-appdata.xml", :expires_in => 1.hour

    unless appdata.blank?
      @name = appdata.application.name.text
      @appcategories = appdata.application.appcategories.each.map{|c| c.text}.reject{|c| c.match(/^X-SuSE/)}.uniq
      @homepage = appdata.application.url.text
    end

    #TODO: get distro spezific screenshot, cache from debshots etc.
    @screenshot = "http://screenshots.debian.net/screenshot/" + @pkgname.downcase

  end

end
 