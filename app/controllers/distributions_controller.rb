# frozen_string_literal: true

class DistributionsController < OBSController
  before_action :set_releases_parameters, only: %i[index testing leap legacy]

  # GET /distributions
  def index
    render layout: 'download'
  end

  # A single action for all supported Leap releases.
  # GET /distributions/leap/(:version)
  def leap
    unless params[:version] || @stable_version
      redirect_to root_url error: _("No stable release available")
      return
    end

    per_leap_version_settings
    return if performed?

    @hide_search_box = true
    @distro_type = "leap"
    begin
      @yaml_data = load_yaml(@version)
      render action: "leap-#{@version}", layout: 'download'
    rescue Errno::ENOENT
      redirect_to leap_distributions_url, error: _("openSUSE Leap Version \"#{@version}\" is currently not availble.")
    end
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    @hide_search_box = true
    @colour = "primary"
    @distro_type = "tumbleweed"
    @yaml_data = YAML.safe_load(ERB.new(File.read("#{Rails.root}/app/data/tumbleweed.yml.erb")).result(binding))
    render layout: 'download'
  end

  private

  def load_yaml(version)
    YAML.safe_load(ERB.new(File.read("#{Rails.root}/app/data/#{version}.yml.erb")).result(binding))
  end

  def per_leap_version_settings
    case parsed_version
    when nil, @stable_version
      stable_settings
    when @testing_version, "testing"
      unless @testing_version
        redirect_to leap_distributions_url, flash: { error: _("No testing distribution available.") }
        return
      end
      testing_settings
    when @legacy_release, "legacy"
      unless @legacy_release
        redirect_to leap_distributions_url, flash: { error: _("No legacy distribution available.") }
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
    @colour = "success"
    @version = @legacy_release
    flash.now[:notice] = _("There is a new version of openSUSE Leap <a href='#{leap_distributions_url}'>available</a>!")
  end

  def stable_settings
    @colour = "success"
    @version = @stable_version
  end

  def testing_settings
    @colour = "dark"
    @version = @testing_version
  end
end
