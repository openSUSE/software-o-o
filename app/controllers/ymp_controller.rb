require 'net/http'

class YmpController < ActionController::Base
  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => {:controller => :main}

  def index
    redirect_to :controller => :main
  end

  def ymp
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:arch]}/#{params[:binary]}?view=ymp"
    req = Net::HTTP::Get.new(path)
    req['x-username'] = "bauersman"

    host, port = API_HOST.split(/:/)
    port ||= 80
    res = Net::HTTP.new(host, port).start do |http|
      http.request(req)
    end
    
    render :text => res.body, :content_type => res.content_type
  end
end
