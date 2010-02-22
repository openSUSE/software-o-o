# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  after_filter :check_memory

  init_gettext('software')

  def rescue_action_in_public(exception)
    @message = exception.message
    if request.xhr?
      render :template => "error", :layout => false, :status => 404
    else
      render :template => 'error', :layout => "application", :status => 404
    end
  end

 private
  def check_memory
    mu = get_memory
    if mu > 80000
      logger.error 'Memory limit reached, ending process'
      `kill -1 #{$$}`
    end
  end
  
  def get_memory
    `ps -o rss= -p #{$$}`.to_i
  end

end
