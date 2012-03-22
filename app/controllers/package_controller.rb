class PackageController < ApplicationController

  before_filter :set_beta_warning
  before_filter :set_search_options, :only => [:show, :categories]
  before_filter :prepare_appdata, :set_categories

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname
    
    @search_term = params[:search_term]
    @base_appdata_project = "openSUSE:Factory"

    @packages = Seeker.prepare_result("\"#{@pkgname}\"", nil, nil, nil, nil)
    @pkgname.downcase!
    # only show rpms
    @packages = @packages.select{|p| p.first.type != 'ymp'}
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

    pkg_appdata = @appdata[:apps].select{|app| app[:pkgname] == @pkgname}
    if ( !pkg_appdata.first.blank? )
      @name = pkg_appdata.first[:name]
      @appcategories = pkg_appdata.first[:categories]
      @homepage = pkg_appdata.first[:homepage]
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
  end


  def category
    required_parameters :category
    @category = params[:category]
    raise MissingParameterError, "Invalid parameter category" unless valid_package_name? @category

    mapping = @main_sections.select{|s| s[:name] == @category }
    if mapping.blank?
      categories = [@category]
    else 
      categories = mapping.first[:categories]
    end

    @packagenames = @appdata[:apps].select{|app| !( app[:categories] & categories ).blank? }.
      map{|p| p[:pkgname]}

    render 'search/find'
  end


  private 

    def set_categories
    @main_sections = [
      {:name => "Games", :categories => ["Game"]},
      {:name => "Education", :categories => ["Education"]},
      {:name => "Development", :categories => ["Development"]},
      {:name => "Office", :categories => ["Office"]},
      {:name => "Tools", :categories => [ "Network", "Settings", "System", "Utility"]},
      {:name => "Multimedia", :categories => ["AudioVideo", "Audio", "Video", "Graphics"]},
    ]
  end


  def prepare_appdata
    @appdata =  Rails.cache.fetch("appdata", :expires_in => 12.hours) do
      data = Hash.new
      data[:apps] = Array.new
      xml = Appdata.get_distribution "factory"
      xml.xpath("/applications/application").each do |app|
        appdata = Hash.new
        appdata[:name] = app.xpath('name').text
        appdata[:pkgname] = app.xpath('pkgname').text
        appdata[:categories] = app.xpath('appcategories/appcategory').map{|c| c.text}.reject{|c| c.match(/^X-/)}.uniq
        appdata[:homepage] = app.xpath('url').text
        data[:apps] << appdata
      end
      data[:categories] = xml.xpath("/applications/application/appcategories/appcategory").
        map{|cat| cat.text}.reject{|c| c.match(/^X-/)}.uniq
      data
    end
  end


end
 
