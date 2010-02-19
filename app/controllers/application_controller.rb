# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'memory_profiler'

class ApplicationController < ActionController::Base

  @memory = 0
  before_filter :memory
  after_filter :logit

  init_gettext('software')

  def initialize
    MemoryProfiler.start :string_debug => false
  end

  def rescue_action_in_public(exception)
    @message = exception.message
    if request.xhr?
      render :template => "error", :layout => false, :status => 404
    else
      render :template => 'error', :layout => "application", :status => 404
    end
  end

  def memory
    @memory = `ps -o rss= -p #{$$}`.to_i
  end

  def logit
    mu = `ps -o rss= -p #{$$}`.to_i
    logger.debug "Request took #{mu-@memory} - now #{mu}"
  end
  
end
