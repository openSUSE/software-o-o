# frozen_string_literal: true

class PackageController < ObsController
  before_action :set_search_options, only: %i[show categories]
  before_action :prepare_appdata, :set_categories

  skip_before_action :set_language, only: %i[thumbnail screenshot]

  def show
    @pkgname = params[:package]
    raise MissingParameterError, 'Invalid parameter package' unless valid_package_name? @pkgname

    begin
      raise OBSError if @distributions.nil?

      @search_term = params[:search_term]

      @packages = OBS.search_published_binary("\"#{@pkgname}\"")
      # only show rpms
      @packages.select! { |p| p.type != 'ymp' && p.quality != 'Private' }
      fix_package_projects
      @default_project_name = @distributions.find { |d| d[:project] == @baseproject }[:name]
      default_update_projects = ["#{@baseproject}:Update", "#{@baseproject}:NonFree:Update"]
      default_release_projects = [@baseproject, "#{@baseproject}:NonFree"]
      @default_package = @packages.find { |p| default_update_projects.include?(p.project) } ||
                         @packages.find { |p| default_release_projects.include?(p.project) }

      pkg_appdata = @appdata[:apps].find { |app| app[:pkgname].casecmp(@pkgname).zero? }
      if pkg_appdata
        @name = pkg_appdata[:name]
        @appcategories = pkg_appdata[:categories]
        @homepage = pkg_appdata[:homepage]
        @appid = pkg_appdata[:id]
      end

      @screenshot = url_for controller: :package, action: :screenshot, package: @pkgname, only_path: true
      @thumbnail = url_for controller: :package, action: :thumbnail, package: @pkgname, only_path: true

      filter_packages

      @official_projects = @distributions.map { |d| d[:project] }
      # get extra distributions that are not in the default distribution list
      @extra_packages = @packages.reject { |p| @distributions.map { |d| d[:project] }.include? p.baseproject }
      @extra_dists = @extra_packages.filter_map(&:baseproject).uniq.map { |d| { project: d } }
    rescue OBSError
      @hide_search_box = true
      flash.now[:error] = _('Connection to OBS is unavailable. Functionality of this site is limited.')
    end
  end

  def explore
    # Workaround to know in advance non-cached screenshots
    # Ideally the apps structure should include Screenshot objects from the beginning
    @apps = @appdata[:apps].reject do |a|
      a[:screenshots].blank? || !Screenshot.new(a[:pkgname], a[:screenshots][0]).thumbnail_generated?
    end
  end

  def category
    @category = params[:category]
    raise MissingParameterError, 'Invalid parameter category' unless valid_package_name? @category

    mapping = @main_sections.select { |s| s[:id].casecmp(@category).zero? }
    categories = (mapping.blank? ? [@category] : mapping.first[:categories])

    app_pkgs = @appdata[:apps].reject { |app| (app[:categories].map(&:downcase) & categories.map(&:downcase)).blank? }
    package_names_unsorted = app_pkgs.map { |p| p[:pkgname] }.uniq
    @packagenames = package_names_unsorted.sort_by { |x| @appdata[:apps].find { |a| a[:pkgname] == x }[:name] }

    app_categories = app_pkgs.map { |p| p[:categories] }.flatten
    reject_categories = %w[GNOME KDE Qt GTK]
    @related_categories = app_categories.uniq.map { |c| { name: c, weight: app_categories.count { |v| v == c } } }
    @related_categories = @related_categories.sort_by { |c| c[:weight] }.reverse.reject { |c| categories.include? c[:name] }
    @related_categories = @related_categories.reject { |c| reject_categories.include? c[:name] }

    render 'search/find'
  end

  def screenshot
    image params[:package], :screenshot
  end

  def thumbnail
    image params[:package], :thumbnail
  end

  private

  def image(pkgname, type)
    @appdata[:apps].each do |app|
      next unless app[:pkgname] == pkgname
      next if app[:screenshots].blank?

      app[:screenshots].each do |image_url|
        return redirect_to(image_url, allow_other_host: true) if type == :screenshot && image_url
        next if image_url.blank?

        path = begin
          screenshot = Screenshot.new(pkgname, image_url)
          screenshot.thumbnail_path(fetch: true)
        rescue OpenURI::HTTPError => e
          Rails.logger.error "Error retrieving #{image_url}: #{e}"
          next
        end
        return redirect_to "/#{path}"
      end
    end

    return head(404, 'content_type' => 'text/plain') if type == :screenshot

    # a screenshot object with nil url returns default thumbnails
    screenshot = Screenshot.new(pkgname, nil)
    path = screenshot.thumbnail_path(fetch: true)
    url = ActionController::Base.helpers.asset_url(path)
    redirect_to url
  end

  # See https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html
  def set_categories
    @main_sections = [
      { name: _('Games'), id: 'Games', icon: 'games', categories: ['Game'] },
      { name: _('Development'), id: 'Development', icon: 'code', categories: ['Development'] },
      { name: _('Education & Science'), id: 'Education', icon: 'education', categories: %w[Education Science] },
      { name: _('Multimedia'), id: 'Multimedia', icon: 'multimedia', categories: %w[AudioVideo Audio Video] },
      { name: _('Graphics'), id: 'Graphics', icon: 'graphics', categories: ['Graphics'] },
      { name: _('Office & Productivity'), id: 'Office', icon: 'office', categories: ['Office'] },
      { name: _('Network'), id: 'Network', icon: 'network', categories: ['Network'] },
      { name: _('System & Utility'), id: 'Tools', icon: 'utils', categories: %w[Settings System Utility] }
    ]
  end
end
