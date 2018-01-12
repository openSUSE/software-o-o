class DistributionsController < ApplicationController
  skip_before_action :set_distributions

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
