require 'net/http'

class MainController < ApplicationController
  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => :index

  def index
  end

  def developer
  end

  def old_dist
    dist = params[:dist]
    begin
      render :template => "main/old_#{dist}.rhtml"
    rescue Object
      @message = "No old page found for dist #{10.2}"
      render :template => "error", :status => 404
    end
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
