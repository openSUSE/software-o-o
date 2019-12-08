# frozen_string_literal: true

class PackageController < OBSController
  before_action :set_search_options, only: %i[show categories]
  before_action :prepare_appdata, :set_categories, only: %i[show explore category thumbnail screenshot]

  skip_before_action :set_language, :set_distributions, :set_baseproject, only: %i[thumbnail screenshot]

  def show
    @pkgname = params[:package]
    raise MissingParameterError, 'Invalid parameter package' unless valid_package_name? @pkgname

    begin
      raise OBSError if @distributions.nil?

      @search_term = params[:search_term]

      @packages = OBS.search_published_binary("\"#{@pkgname}\"")
      # only show rpms
      @packages.select! { |p| p.type != 'ymp' && p.quality != 'Private' }
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
      end

      @screenshot = url_for controller: :package, action: :screenshot, package: @pkgname, protocol: request.protocol
      @thumbnail = url_for controller: :package, action: :thumbnail, package: @pkgname, protocol: request.protocol

      filter_packages

      @packages.each do |package|
        # Backports chains up to the toolchain module for newer GCC.
        # So break the link immediately.
        if /^openSUSE:Backports:SLE-12/.match?(package.project)
          package.baseproject = package.project
        end
      end

      @official_projects = @distributions.map { |d| d[:project] }
      # get extra distributions that are not in the default distribution list
      @extra_packages = @packages.reject { |p| @distributions.map { |d| d[:project] }.include? p.baseproject }
      @extra_dists = @extra_packages.map(&:baseproject).reject(&:nil?).uniq.map { |d| { project: d } }
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
    @related_categories = app_categories.uniq.map { |c| { name: c, weight: app_categories.count { |v| v == c } } }
    @related_categories = @related_categories.sort_by { |c| c[:weight] }.reverse.reject { |c| categories.include? c[:name] }
    @related_categories = @related_categories.reject { |c| %w[GNOME KDE Qt GTK].include? c[:name] }

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
        return redirect_to image_url if type == :screenshot && image_url
        next if image_url.blank?

        path = begin
                 screenshot = Screenshot.new(pkgname, image_url)
                 screenshot.thumbnail_path(fetch: true)
               rescue StandardError => e
                 Rails.logger.error "Error retrieving #{image_url}: #{e}"
                 next
               end
        return redirect_to '/' + path
      end
    end

    return head(404, 'content_type' => 'text/plain') if type == :screenshot

    # a screenshot object with nil url returns default thumbnails
    screenshot = Screenshot.new(pkgname, nil)
    path = screenshot.thumbnail_path(fetch: true)
    url = ActionController::Base.helpers.asset_url(path)
    redirect_to url
  end

  # See https://specifications.freedesktop.org/menu-spec/1.0/apa.html
  def set_categories
    @main_sections = [
      { name: _('Games'), id: 'Games', icon: 'puzzle-outline', categories: ['Game'] },
      { name: _('Development'), id: 'Development', icon: 'code-outline', categories: ['Development'] },
      { name: _('Education & Science'), id: 'Education', icon: 'globe-outline', categories: %w[Education Science] },
      { name: _('Multimedia'), id: 'Multimedia', icon: 'notes-outline', categories: %w[AudioVideo Audio Video] },
      { name: _('Graphics'), id: 'Graphics', icon: 'brush', categories: ['Graphics'] },
      { name: _('Office & Productivity'), id: 'Office', icon: 'document', categories: ['Office'] },
      { name: _('Network'), id: 'Network', icon: 'world-outline', categories: ['Network'] },
      { name: _('System & Utility'), id: 'Tools', icon: 'spanner-outline', categories: %w[Settings System Utility] }
    ]
  end
end
