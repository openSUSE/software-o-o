class DistributionsController < ApplicationController
  skip_before_filter :set_distributions

  # GET /distributions
  def index
    render layout: 'download'
  end

  # GET /distributions/leap
  def leap
    render layout: 'download'
  end

  # GET /distributions/leap/ports
  def leap_ports
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
