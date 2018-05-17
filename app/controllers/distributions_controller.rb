class DistributionsController < ApplicationController
  before_action :set_parameters, only: %i[index testing leap]

  RELEASES_FILE = Rails.root.join('config', 'releases.yml').freeze

  def load_releases
    Rails.cache.fetch('software-o-o/releases', expires_in: 10.minutes) do
      begin
        YAML.load_file(RELEASES_FILE).map do |release|
          release['from'] = Time.parse(release['from'])
          release
        end
      rescue => e
        Rails.logger.error "Error while parsing releases entry in #{RELEASES_FILE}: #{e}"
        next
      end.compact.sort_by do |release|
        -release['from'].to_i
      end
    end
  rescue => e
    Rails.logger.error "Error while parsing releases file #{RELEASES_FILE}: #{e}"
    raise e
  end

  def set_parameters
    @stable_version = nil
    @testing_version = nil
    @testing_state = nil
    @legacy_release = nil

    # look for most current release
    releases = load_releases
    current = unless releases.empty?
                now = Time.now
                # drop all upcoming releases
                upcoming = releases.reject do |release|
                  release['from'] > now
                end

                upcoming.empty? ? releases.last : upcoming.first
              end

    return unless current
    @stable_version = current['stable_version']
    @testing_version = current['testing_version']
    @testing_state = current['testing_state']
    @legacy_release = current['legacy_release']
  end

  # GET /distributions
  def index
    render layout: 'download'
  end

  # GET /distributions/leap
  def leap
    unless @stable_version
      redirect_to '/', flash: { error: _("No stable release available") }
      return
    end
    @version = @stable_version
    render action: "leap-#{@stable_version}", layout: 'download'
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    render layout: 'download'
  end

  # GET /distributions/testing
  def testing
    unless @testing_version
      redirect_to '/distributions/leap', flash: { error: _("No testing distribution available.") }
      return
    end
    @version = @testing_version
    flash[:notice] = _('Help test the next version of openSUSE Leap!')
    render action: "leap-#{@testing_version}", layout: 'download'
  end
end
