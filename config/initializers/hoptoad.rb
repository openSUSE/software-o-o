HoptoadNotifier.configure do |h|
  config = Rails.configuration.x
  # Change this to some sensible data for your errbit instance
  h.api_key = config.errbit_api_key || 'YOUR_ERRBIT_API_KEY'
  h.host    = config.errbit_host || 'YOUR_ERRBIT_HOST'
  if config.errbit_api_key.blank? || config.errbit_host.blank?
    h.development_environments = "production development test"
  else
    h.development_environments = "development test"
  end

  h.ignore_only = %w{ 
  ActiveRecord::RecordNotFound
  ActionController::InvalidAuthenticityToken
  CGI::Session::CookieStore::TamperedWithCookie
  ActionController::UnknownAction
  AbstractController::ActionNotFound
  Timeout::Error
  Net::HTTPBadResponse
  }
 
  h.ignore_by_filter do |exception_data|
    ret=false
    if exception_data[:error_class] == "ActionController::RoutingError" 
      message = exception_data[:error_message]
      ret=true if message =~ %r{Required Parameter}
      ret=true if message =~ %r{\[GET\]}
      ret=true if message =~ %r{Expected AJAX call}
    end
    ret
  end

end
