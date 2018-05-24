class PackageController < ApplicationController
  # before_action :set_beta_warning, :only => [:category, :categories]
  before_action :set_search_options, :only => %i[show categories]
  before_action :prepare_appdata, :set_categories, :only => %i[show explore category thumbnail screenshot]

  skip_before_action :set_language, :set_distributions, :only => %i[thumbnail screenshot]

  def show
    required_parameters :package
    @pkgname = params[:package]
    raise MissingParameterError, "Invalid parameter package" unless valid_package_name? @pkgname

    @search_term = params[:search_term]
    @base_appdata_project = "openSUSE:Factory"

    @packages = Seeker.prepare_result("\"#{@pkgname}\"", nil, nil, nil, nil)
    # only show rpms
    @packages = @packages.select {|p| p.first.type != 'ymp' && p.quality != "Private"}
    @default_project = @baseproject
    @default_project_name = @distributions.select {|d| d[:project] == @default_project}.first[:name]
    @default_repo = @distributions.select {|d| d[:project] == @default_project}.first[:repository]
    @default_package = if (!@packages.select {|s| s.project == "#{@default_project}:Update"}.empty?)
                         @packages.select {|s| s.project == "#{@default_project}:Update"}.first
                       else
                         @packages.select {|s| [@default_project, "#{@default_project}:NonFree"].include? s.project}.first
                       end

    pkg_appdata = @appdata[:apps].select {|app| app[:pkgname].downcase == @pkgname.downcase}
    if (!pkg_appdata.first.blank?)
      @name = pkg_appdata.first[:name]
      @appcategories = pkg_appdata.first[:categories]
      @homepage = pkg_appdata.first[:homepage]
    end

    @screenshot = url_for :controller => :package, :action => :screenshot, :package => @pkgname, protocol: request.protocol
    @thumbnail = url_for :controller => :package, :action => :thumbnail, :package => @pkgname, protocol: request.protocol

    filter_packages

    @packages.each do |package|
      # Backports chains up to the toolchain module for newer GCC.
      # So break the link immediately.
      if (package.project.match(/^openSUSE:Backports:SLE-12/))
        package.baseproject = package.project
      end
    end

    @official_projects = @distributions.map {|d| d[:project]}
    # get extra distributions that are not in the default distribution list
    @extra_packages = @packages.reject {|p| @distributions.map {|d| d[:project]}.include? p.baseproject }
    @extra_dists = @extra_packages.map {|p| p.baseproject}.reject {|d| d.nil?}.uniq.map {|d| { :project => d }}
  end

  def explore
    # Workaround to know in advance non-cached screenshots
    # Ideally the apps structure should include Screenshot objects from the beginning
    @apps = @appdata[:apps].reject do |a|
      a[:screenshots].blank? || !Screenshot.new(a[:pkgname], a[:screenshots][0]).thumbnail_generated?
    end
  end

  def category
    required_parameters :category
    @category = params[:category]
    raise MissingParameterError, "Invalid parameter category" unless valid_package_name? @category

    mapping = @main_sections.select {|s| s[:id].downcase == @category.downcase }
    categories = (mapping.blank? ? [@category] : mapping.first[:categories])

    app_pkgs = @appdata[:apps].reject {|app| (app[:categories].map {|c| c.downcase} & categories.map {|c| c.downcase}).blank? }
    @packagenames = app_pkgs.map {|p| p[:pkgname]}.uniq.sort_by {|x| @appdata[:apps].select {|a| a[:pkgname] == x}.first[:name] }

    app_categories = app_pkgs.map {|p| p[:categories]}.flatten
    @related_categories = app_categories.uniq.map {|c| { :name => c, :weight => app_categories.select {|v| v == c }.size } }
    @related_categories = @related_categories.sort_by { |c| c[:weight] }.reverse.reject {|c| categories.include? c[:name] }
    @related_categories = @related_categories.reject {|c| ["GNOME", "KDE", "Qt", "GTK"].include? c[:name] }

    render 'search/find'
  end

  def screenshot
    required_parameters :package
    image params[:package], :screenshot
  end

  def thumbnail
    required_parameters :package
    image params[:package], :thumbnail
  end

  private

  def image(pkgname, type)
    @appdata[:apps].each do |app|
      next unless app[:pkgname] == pkgname
      next if app[:screenshots].blank?

      app[:screenshots].each do |image_url|
        return redirect_to image_url if type == :screenshot && image_url
        next if image_url.blank?

        path = begin
                 screenshot = Screenshot.new(pkgname, image_url)
                 screenshot.thumbnail_path(fetch: true)
               rescue => e
                 Rails.logger.error "Error retrieving #{image_url}: #{e}"
                 next
               end
        return redirect_to '/' + path
      end
    end

    head 404, "content_type" => 'text/plain' if type == :screenshot
    # a screenshot object with nil url returns default thumbnails
    screenshot = Screenshot.new(pkgname, nil)
    path = screenshot.thumbnail_path(fetch: true)
    url = ActionController::Base.helpers.asset_url(path)
    redirect_to url
  end

  # See https://specifications.freedesktop.org/menu-spec/1.0/apa.html
  def set_categories
    @main_sections = [
      { :name => _("Games"), :id => "Games", :icon => "puzzle-outline", :categories => ["Game"] },
      { :name => _("Development"), :id => "Development", :icon => "code-outline", :categories => ["Development"] },
      { :name => _("Education & Science"), :id => "Education", :icon => "globe-outline", :categories => ["Education", "Science"] },
      { :name => _("Multimedia"), :id => "Multimedia", :icon => "notes-outline", :categories => ["AudioVideo", "Audio", "Video"] },
      { :name => _("Graphics"), :id => "Graphics", :icon => "brush", :categories => ["Graphics"] },
      { :name => _("Office & Productivity"), :id => "Office", :icon => "document", :categories => ["Office"] },
      { :name => _("Network"), :id => "Network", :icon => "world-outline", :categories => ["Network"] },
      { :name => _("System & Utility"), :id => "Tools", :icon => "spanner-outline", :categories => ["Settings", "System", "Utility"] },
    ]
  end
end
