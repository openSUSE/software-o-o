class DistributionsController < ApplicationController
  before_action :set_testing, only: %i[index testing]

  def set_testing
    @testing_version = current_release[:testing_version]
    @testing_state = current_release[:testing_state]
  end

  # GET /distributions
  def index
    render layout: 'download'
  end

  # GET /distributions/leap
  def leap
    render layout: 'download'
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    render layout: 'download'
  end

  # GET /distributions/testing
  def testing
    render layout: 'download'
  end
end
