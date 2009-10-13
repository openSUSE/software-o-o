require 'net/http'

class MainController < ApplicationController
  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => :index


  def old_dist
    dist = params[:dist]
    begin
      render :template => "main/old_#{dist}.rhtml"
    rescue Object
      @message = "No old page found for dist #{dist}"
      render :template => "error", :status => 404
    end
  end

  def ymp_with_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:arch]}/#{params[:binary]}?view=ymp"
    res = get_from_api(path)
    render :text => res.body, :content_type => res.content_type
  end

  def ymp_without_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:package]}?view=ymp"
    res = get_from_api(path)
    render :text => res.body, :content_type => res.content_type
  end

  private
  
  def get_from_api(path)
    req = Net::HTTP::Get.new(path)
    req['x-username'] = "obs_read_only"

    host, port = API_HOST.split(/:/)
    port ||= 80
    res = Net::HTTP.new(host, port).start do |http|
      http.request(req)
    end
  end
end
