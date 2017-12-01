class DistributionsController < ApplicationController
  skip_before_filter :set_distributions

  # GET /distributions
  def index
    render layout: 'jekyll'
  end

  # GET /distributions/leap
  def leap
    render layout: 'jekyll'
  end

  # GET /distributions/leap/ports
  def leap_ports
    render layout: 'jekyll'
  end

  # GET /distributions/tumbleweed
  def tumbleweed
    render layout: 'jekyll'
  end

  # GET /distributions/tumbleweed/ports
  def tumbleweed_ports
    render layout: 'jekyll'
  end

  # GET /distributions/tumbleweed/unsupported
  def tumbleweed_unsupported
    render layout: 'jekyll'
  end

  # GET /distributions/testing
  def testing
    render layout: 'jekyll'
  end
end
