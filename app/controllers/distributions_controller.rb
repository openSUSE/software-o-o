class DistributionsController < OBSController
  before_action :set_releases_parameters, only: %i[index testing leap]

  # GET /distributions
  def index
    render layout: 'download'
  end

  # GET /distributions/leap
  def leap
    @hide_search_box = true
    unless @stable_version
      redirect_to '/', flash: { error: _("No stable release available") }
      return
    end
    @version = @stable_version
    render action: "leap-#{@stable_version}", layout: 'download'
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    @hide_search_box = true
    render layout: 'download'
  end

  # GET /distributions/testing
  def testing
    @hide_search_box = true
    unless @testing_version
      redirect_to '/distributions/leap', flash: { error: _("No testing distribution available.") }
      return
    end
    @version = @testing_version
    flash[:notice] = _('Help test the next version of openSUSE Leap!')
    render action: "leap-#{@testing_version}", layout: 'download'
  end
end
