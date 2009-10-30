require 'net/http'
require 'gettext_rails'

class MainController < ApplicationController

  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => :index

  # these pages are completely static:
  caches_page :release, :download_js

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

  def set_release(release)
    if release == "111"
       @isos = {}
       @directory = "http://download.opensuse.org/distribution/11.1"
       @isos["lang-32"] = "11.1-Addon-Lang-i586"
       @isos["lang-64"] = "11.1-Addon-Lang-x86_64"
       @isos["nonoss"] = "11.1-Addon-NonOss-BiArch-i586-x86_64"
       @isos["kde-64"] = "11.1-KDE4-LiveCD-x86_64"
       @isos["kde-32"] = "11.1-KDE4-LiveCD-i686"
       @isos["gnome-64"] = "11.1-GNOME-LiveCD-x86_64"
       @isos["gnome-32"] = "11.1-GNOME-LiveCD-i686"
       @isos["dvd-64"] = "11.1-DVD-x86_64"
       @isos["dvd-32"] = "11.1-DVD-i586"
       @isos["net-32"] = "11.1-NET-i586"
       @isos["net-64"] = "11.1-NET-x86_64"

       @releasenotes = "http://www.suse.de/relnotes/i386/openSUSE/11.1/RELEASE-NOTES.en.html"
       @releasename = "openSUSE 11.1"
       @repourl = "http://download.opensuse.org/distribution/11.1"
       @medium = "dvd"
    elsif release == "112"
       @isos = {}
       @directory = "http://download.opensuse.org/distribution/11.2"
       @isos["lang-32"] = "11.2-Addon-Lang-i586"
       @isos["lang-64"] = "11.2-Addon-Lang-x86_64"
       @isos["nonoss"] = "11.2-Addon-NonOss-BiArch-i586-x86_64"
       @isos["kde-64"] = "11.2-KDE4-LiveCD-x86_64"
       @isos["kde-32"] = "11.2-KDE4-LiveCD-i686"
       @isos["gnome-64"] = "11.2-GNOME-LiveCD-x86_64"
       @isos["gnome-32"] = "11.2-GNOME-LiveCD-i686"
       @isos["dvd-64"] = "11.2-DVD-x86_64"
       @isos["dvd-32"] = "11.2-DVD-i586"
       @isos["net-32"] = "11.2-NET-i586"
       @isos["net-64"] = "11.2-NET-x86_64"

       @releasenotes = "http://www.suse.de/relnotes/i386/openSUSE/11.2/RELEASE-NOTES.en.html"
       @releasename = "openSUSE 11.2"
       @repourl = "http://download.opensuse.org/distribution/11.2"
       @medium = "dvd"
    elsif release == "developer"
       @isos = {}
       @directory = "http://download.opensuse.org/distribution/11.2-RC2"
       @isos["lang-32"] = "Addon-Lang-Build0339-i586"
       @isos["lang-64"] = "Addon-Lang-Build0339-x86_64"
       @isos["nonoss"] = "Addon-NonOss-BiArch-Build0339-i586-x86_64"
       @isos["kde-64"] = "KDE4-LiveCD-Build0339-x86_64"
       @isos["kde-32"] = "KDE4-LiveCD-Build0339-i686"
       @isos["gnome-64"] = "GNOME-LiveCD-Build0339-x86_64"
       @isos["gnome-32"] = "GNOME-LiveCD-Build0339-i686"
       @isos["dvd-64"] = "DVD-Build0339-x86_64"
       @isos["dvd-32"] = "DVD-Build0339-i586"
       @isos["net-32"] = "NET-Build0339-i586"
       @isos["net-64"] = "NET-Build0339-x86_64"

       @releasenotes = "http://www.suse.de/relnotes/i386/openSUSE/11.2/RELEASE-NOTES.en.html"
       @releasename = "openSUSE 11.2-RC2"
       @repourl = "http://download.opensuse.org/distribution/11.2"
       @medium = "dvd"
    end
    @release = release
  end

  def developer
    if params[:lang].nil?
      lang = request.compatible_language_from(LANGUAGES) || "en"
    else
      lang = params[:lang][0]
    end
    redirect_to "/developer/" + lang
  end
   
  def index
    #GetText.locale = "en"
    #render :template => "main/index"
    #return

    if params[:lang].nil?
      lang = request.compatible_language_from(LANGUAGES) || "en"
    else
      lang = params[:lang][0]
    end
    redirect_to "/111/" + lang
  end

  def release
    @lang = params[:lang][0]
    GetText.locale = @lang

    set_release(params[:release])
    render :template => "main/release"
  end

  def change_install
    set_release(params[:release])
    @medium = params[:medium]
    render :template => "main/release"
  end

  def download_js
    set_release(params[:release])
    render :template => "main/download", :content_type => 'text/javascript', :layout => false
  end

  def download
    set_release(params[:release])
    medium = params[:medium]

    if params[:arch] == "i686"
      medium += "-32"
    else
      medium += "-64"
    end

    suffix = ".iso"
    
    case
    when params[:protocol] == "torrent"
      if params[:medium] != "net"
          suffix = ".iso.torrent"
      end
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
