# frozen_string_literal: true

class DistributionsController < OBSController
  before_action :set_releases_parameters, only: %i[index testing leap legacy]

  # GET /distributions
  def index
    @hide_search_box = true
    render layout: 'download'
  end

  # GET /distributions/server
  def server
    @hide_search_box = true
    render layout: 'download'
  end

  # GET /distributions/desktop
  def desktop
    @hide_search_box = true
    render layout: 'download'
  end

  # A single action for all supported Leap releases.
  # GET /distributions/leap/(:version)
  def leap
    unless params[:version] || @stable_version
      redirect_to root_url error: _('No stable release available')
      return
    end

    per_leap_version_settings
    return if performed?

    @hide_search_box = true
    @distro_type = 'Leap'
    begin
      @yaml_data = load_yaml(@distro_type, @version)
      render action: "distribution", layout: 'download'
    rescue Errno::ENOENT
      redirect_to leap_distributions_url, error: _("openSUSE Leap Version \"#{@version}\" is currently not availble.")
    end
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    @hide_search_box = true
    @bg_colour = 'primary'
    @fg_colour = 'black'
    @distro_type = 'Tumbleweed'
    @yaml_data = load_yaml(@distro_type)
    render action: "distribution", layout: 'download'
  end

  # GET /distributions/kubic
  def kubic
    @hide_search_box = true
    @bg_colour = 'info'
    @fg_colour = 'black'
    @distro_type = 'Kubic'
    @yaml_data = load_yaml(@distro_type)
    render action: "distribution", layout: 'download'
  end

  # GET /distributions/microos
  def microos
    @hide_search_box = true
    @bg_colour = 'microos'
    @fg_colour = 'white'
    @distro_type = 'MicroOS'
    @yaml_data = load_yaml(@distro_type)
    render action: "distribution", layout: 'download'
  end

  private

  def load_yaml(type, version=nil)
    YAML.safe_load(ERB.new(File.read("#{Rails.root}/app/data/#{version ? version : type}.yml.erb")).result(binding))
  end

  def per_leap_version_settings
    case parsed_version
    when nil, @stable_version
      stable_settings
    when @testing_version, 'testing'
      unless @testing_version
        redirect_to leap_distributions_url, flash: { error: _('No testing distribution available.') }
        return
      end
      testing_settings
    when @legacy_release, 'legacy'
      unless @legacy_release
        redirect_to leap_distributions_url, flash: { error: _('No legacy distribution available.') }
        return
      end
      legacy_settings
    else
      redirect_to leap_distributions_url, flash: { error: _("openSUSE Leap Version #{parsed_version} not found.") }
    end
  end

  def parsed_version
    params[:version].try(:tr, '_', '.')
  end

  def legacy_settings
    @bg_colour = 'warning'
    @fg_colour = 'black'
    @version = @legacy_release
    flash.now[:notice] = _("There is a new version of openSUSE Leap <a href='#{leap_distributions_url}'>available</a>!")
  end

  def stable_settings
    @bg_colour = 'warning'
    @fg_colour = 'black'
    @version = @stable_version
  end

  def testing_settings
    @bg_colour = 'dark'
    @fg_colour = 'white'
    @version = @testing_version
  end
end
