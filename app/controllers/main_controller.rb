require 'net/http'
require 'gettext_rails'

class MainController < ApplicationController

  verify :only => :ymp, :params => [:project, :repository, :arch, :binary],
    :redirect_to => :index

  # these pages are completely static:
  caches_page :release, :download_js

  def ymp_with_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:arch]}/#{params[:binary]}?view=ymp"
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :ymp => path
    res =  Rails.cache.fetch( Rails.cache.escape_key( "ymp_#{path}"  ), :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :text => res.body, :content_type => res.content_type
  end

  def ymp_without_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:package]}?view=ymp"
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :ymp => path
    res =  Rails.cache.fetch( Rails.cache.escape_key( "ymp_#{path}"  ), :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :text => res.body, :content_type => res.content_type
  end

  def set_release(release)
    if release == "113"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/11.3"
      @isos["lang-32"] = "11.3-Addon-Lang-i586"
      @isos["lang-64"] = "11.3-Addon-Lang-x86_64"
      @isos["nonoss"] = "11.3-Addon-NonOss-BiArch-i586-x86_64"
      @isos["kde-64"] = "11.3-KDE4-LiveCD-x86_64"
      @isos["kde-32"] = "11.3-KDE4-LiveCD-i686"
      @isos["gnome-64"] = "11.3-GNOME-LiveCD-x86_64"
      @isos["gnome-32"] = "11.3-GNOME-LiveCD-i686"
      @isos["dvd-64"] = "11.3-DVD-x86_64"
      @isos["dvd-32"] = "11.3-DVD-i586"
      @isos["net-32"] = "11.3-NET-i586"
      @isos["net-64"] = "11.3-NET-x86_64"

      @releasenotes = _("http://www.suse.de/relnotes/i386/openSUSE/11.3/RELEASE-NOTES.en.html")
      @releasename = "openSUSE 11.3"
      @repourl = "http://download.opensuse.org/distribution/11.3"
      @medium = "dvd"
    elsif release == "114"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/11.4"
      @isos["lang-32"] = "11.4-Addon-Lang-i586"
      @isos["lang-64"] = "11.4-Addon-Lang-x86_64"
      @isos["nonoss"] = "11.4-Addon-NonOss-BiArch-i586-x86_64"
      @isos["kde-64"] = "11.4-KDE-LiveCD-x86_64"
      @isos["kde-32"] = "11.4-KDE-LiveCD-i686"
      @isos["gnome-64"] = "11.4-GNOME-LiveCD-x86_64"
      @isos["gnome-32"] = "11.4-GNOME-LiveCD-i686"
      @isos["dvd-64"] = "11.4-DVD-x86_64"
      @isos["dvd-32"] = "11.4-DVD-i586"
      @isos["net-32"] = "11.4-NET-i586"
      @isos["net-64"] = "11.4-NET-x86_64"

      @releasenotes = _("http://www.suse.de/relnotes/i386/openSUSE/11.4/RELEASE-NOTES.en.html")
      @releasename = "openSUSE 11.4"
      @repourl = "http://download.opensuse.org/distribution/11.4"
      @medium = "dvd"
    elsif release == "121"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/12.1"
      @isos["lang-32"] = "12.1-Addon-Lang-i586"
      @isos["lang-64"] = "12.1-Addon-Lang-x86_64"
      @isos["nonoss"] = "12.1-Addon-NonOss-BiArch-i586-x86_64"
      @isos["kde-64"] = "12.1-KDE-LiveCD-x86_64"
      @isos["kde-32"] = "12.1-KDE-LiveCD-i686"
      @isos["gnome-64"] = "12.1-GNOME-LiveCD-x86_64"
      @isos["gnome-32"] = "12.1-GNOME-LiveCD-i686"
      @isos["dvd-64"] = "12.1-DVD-x86_64"
      @isos["dvd-32"] = "12.1-DVD-i586"
      @isos["net-32"] = "12.1-NET-i586"
      @isos["net-64"] = "12.1-NET-x86_64"

      @releasenotes = _("http://www.suse.de/relnotes/i386/openSUSE/12.1/RELEASE-NOTES.en.html")
      @releasename = "openSUSE 12.1"
      @repourl = "http://download.opensuse.org/distribution/12.1"
      @medium = "dvd"
    elsif release == "developer"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/12.2-Milestone3"
      @isos["lang-32"] = "Addon-Lang-Build0317-i586"
      @isos["lang-64"] = "Addon-Lang-Build0317-x86_64"
      @isos["nonoss"] = "Addon-NonOss-BiArch-Build0317-i586-x86_64"
      @isos["kde-64"] = "KDE-LiveCD-Build0318-x86_64"
      @isos["kde-32"] = "KDE-LiveCD-Build0318-i686"
      @isos["gnome-64"] = "GNOME-LiveCD-Build0318-x86_64"
      @isos["gnome-32"] = "GNOME-LiveCD-Build0318-i686"
      @isos["dvd-64"] = "DVD-Build0315-x86_64"
      @isos["dvd-32"] = "DVD-Build0317-i586"
      @isos["net-32"] = "NET-Build0317-i586"
      @isos["net-64"] = "NET-Build0315-x86_64"

      @releasenotes = _("http://www.suse.de/relnotes/i386/openSUSE/12.2/RELEASE-NOTES.en.html")
      @releasename = "openSUSE 12.2 Milestone 3"
      @repourl = "http://download.opensuse.org/distribution/12.2"
      @medium = "dvd"
    end
    @release = release
  end

  def redirectit(release)
    if request.user_agent && request.user_agent.index('Mozilla/5.0 (compatible; Konqueror/3')
      notice = _("Konqueror of KDE 3 is unfortunately unmaintained and its javascript implementation contains bugs that " +
          "make it impossible to use with this page. Please make sure you have javascript disabled before you " +
          "<a href='%s'>continue</a>.") % url
      render :template => "main/redirect_with_notice", :locals => { :notice => notice } and return
    end
    redirect_to :action => 'release', :release => release, :lang => @lang
  end


  def developer
    redirectit("developer") and return
    flash.now[:warn] = _("We currently don't have a Factory Snapshot that is more recent than our last openSUSE release. <br/>" +
        "Please check <a href='http://en.opensuse.org/Portal:Factory'>http://en.opensuse.org/Portal:Factory</a> for more information.")
    @exclude_debug = true
    @include_home = 'false'
    set_release("121")
    render :template => "main/release"
  end


  def index
    redirectit("121")
  end

  def release
    @exclude_debug = true
    @include_home = 'false'
    flash.now[:info] = _("Please note that this is not the latest openSUSE release. You can get the latest version <a href='/'>here</a>. ") if params[:outdated]
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

  def show_request
    render :template => "main/testrequest", :layout => false
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
      suffix = ".iso.meta4"
    end
    redirect_to @directory + "/iso/openSUSE-" + @isos[medium] + suffix

  end

  def top_downloads
    respond_to do |format|
      format.xml  { render(:layout => false, :content_type => 'text/xml' ) }
    end
  end

end
