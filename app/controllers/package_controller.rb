class PackageController < ApplicationController

  before_filter :set_beta_warning
  before_filter :set_search_options, :only => [:show, :categories]

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname
    @pkgname.downcase!

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
    # Also caching unavailability of appdata
    if Rails.cache.read( "appdata-" + @pkgname).nil?
      appdata = Appdata.find_cached( :prj => @base_appdata_project, :repo => @default_repo, :arch => "i586",
        :pkgname => @pkgname, :appdata => "#{@pkgname}-appdata.xml", :expires_in => 3.hours )
      Rails.cache.write( "appdata-" + @pkgname, "", :expires_in => 3.hours  ) if appdata.nil?
    end

    if ( !appdata.blank? )
      @name = appdata.application.name.text
      @appcategories = appdata.application.appcategories.each.map{|c| c.text}.reject{|c| c.match(/^X-SuSE/)}.uniq
      @homepage = appdata.application.url.text if appdata.application.url
    end

    #TODO: get distro spezific screenshot, cache from debshots etc.
    @screenshot = "http://screenshots.debian.net/screenshot/" + @pkgname

    #TODO: sort out tumbleweed packages as seperate repo, maybe obs can mark that as seperate baseproject? 
    @packages.each do |package|
      if ( package.repository.match(/openSUSE_Tumbleweed/) || (package.project == "openSUSE:Tumbleweed") )
        package.baseproject = "openSUSE:Tumbleweed"
      end

    end
  end


  def categories

    @appdata =  Rails.cache.fetch("appdata", :expires_in => 12.hours) do
      data = Hash.new
      data[:apps] = Array.new
      xml = Appdata.get_distribution "factory"

      xml.xpath("/applications/application").each do |app|
        appdata = Hash.new
        appdata[:name] = app.xpath('name').text
        appdata[:pkgname] = app.xpath('pkgname').text
        appdata[:categories] = app.xpath('appcategories/appcategory').map{|c| c.text}.reject{|c| c.match(/^X-SuSE/)}.uniq
        data[:apps] << appdata
      end

      data[:categories] = xml.xpath("/applications/application/appcategories/appcategory").
        map{|cat| cat.text}.reject{|c| c.match(/^X-SuSE/)}.uniq

      data
    end

  end


end
 
