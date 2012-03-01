class PackageController < ApplicationController

  before_filter :set_beta_warning

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname

    @base_appdata_project = "openSUSE:Factory"

    @packages = Seeker.prepare_result("\"#{@pkgname}\"", nil, nil, nil, nil)
    @default_project = @template.default_baseproject
    @default_project_name = @distributions.select{|d| d[:project] == @default_project}.first[:name]
    @default_repo = @distributions.select{|d| d[:project] == @default_project}.first[:repository]
    @default_package = @packages.select{|s| s.project == (@default_project)}.first

    # Fetch appstream data for app
    appdata = Appdata.find_cached :prj => @base_appdata_project, :repo => @default_repo, :arch => "i586",
      :pkgname => @pkgname, :appdata => "#{@pkgname}-appdata.xml", :expires_in => 1.hour

    unless appdata.blank?
      @name = appdata.application.name.text
      @appcategories = appdata.application.appcategories.each.map{|c| c.text}
      @homepage = appdata.application.url.text
    end

    # TODO: released projects don't give info over the api... (bnc#749828)
    @packages.each do |package|
      unless package.description.blank?
        @description_package = package
        logger.debug "Found package description in: #{package.project}"
        break
      end
      logger.debug "No package description in: #{package.project}"
    end

    #TODO: get distro spezific screenshot, cache from debshots etc.
    @screenshot_thumb = "http://screenshots.debian.net/thumbnail/" + @pkgname

  end


  def set_beta_warning
    flash.now[:info] = "This is an alpha version of the new package search, part of " +
      "the <a href='https://trello.com/board/appstream/4f156e1c9ce0824a2e1b8831'>current boosters sprint</a>!"
  end


end
 