class DistributionsController < ApplicationController
  skip_before_action :set_distributions
  before_action :set_parameters, only: [:index, :testing]

  def set_parameters
    @testing_version = '15.0'
    @testing_state = 'Beta'
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
