require 'net/http'
require 'gettext_rails'

class MainController < ApplicationController

  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => :index

  # these pages are completely static:
  caches_page :index, :developer, :developer2, :developer_download_js

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

  def set_developer
    @isos = {}
    @directory = "http://download.opensuse.org/distribution/11.2-RC1"
    @isos["lang-32"] = "Addon-Lang-Build0331-i586"
    @isos["lang-64"] = "Addon-Lang-Build0332-x86_64"
    @isos["nonoss"] = "Addon-NonOss-BiArch-Build0335-i586-x86_64"
    @isos["kde-64"] = "KDE4-LiveCD-Build0336-x86_64"
    @isos["kde-32"] = "KDE4-LiveCD-Build0336-i686"
    @isos["gnome-64"] = "GNOME-LiveCD-Build0336-x86_64"
    @isos["gnome-32"] = "GNOME-LiveCD-Build0336-i686"
    @isos["dvd-64"] = "DVD-Build0334-x86_64"
    @isos["dvd-32"] = "DVD-Build0331-i586"
    @isos["net-32"] = "NET-Build0331-i586"
    @isos["net-64"] = "NET-Build0331-x86_64"

    @releasenotes = "http://www.suse.de/relnotes/i386/openSUSE/11.2/RELEASE-NOTES.en.html"
    @releasename = "openSUSE 11.2-RC1"
    @repourl = "http://download.opensuse.org/distribution/11.2"
    @medium = "dvd"
  end

  def developer
    set_developer
    render :template => "main/developer"
  end

  def developer2
    
    if params[:lang].nil?
      lang = request.compatible_language_from(LANGUAGES) || "en"
      redirect_to "/developer2/" + lang
      return
    else
      @lang = params[:lang][0]
    end
    GetText.locale = @lang

    set_developer
    render :template => "main/developer2"
  end

  def change_developer_install
    set_developer
    @medium = params[:medium]
    render :template => "main/developer2"
  end

  def developer_download_js
    set_developer
    render :template => "main/download", :content_type => 'text/javascript', :layout => false
  end

  def download
    if params[:release] == "developer"
      set_developer
    end
 
    medium = params[:medium]

    if params[:arch] == "i686"
      medium += "-32"
    else
      medium += "-64"
    end

    suffix = ".iso"
    
    case
    when params[:protocol] == "torrent"
      suffix = ".iso.torrent"
    when params[:protocol] == "mirror"
      suffix = ".iso?mirrorlist"
    when params[:protocol] == "metalink"
      suffix = ".iso.metalink"
    end
    redirect_to @directory + "/iso/openSUSE-" + @isos[medium] + suffix

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
