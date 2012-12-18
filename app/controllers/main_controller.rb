require 'net/http'

class MainController < ApplicationController

  # these pages are completely static:
  caches_page :release, :download_js unless Rails.env.development?

  def ymp_with_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:arch]}/#{params[:binary]}?view=ymp"
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :ymp => path
    res =  Rails.cache.fetch( "ymp_#{path}", :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :text => res.body, :content_type => res.content_type
  end

  def ymp_without_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:package]}?view=ymp"
    DownloadHistory.create :query => params[:query], :base => params[:base],
      :ymp => path
    res =  Rails.cache.fetch("ymp_#{path}", :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :text => res.body, :content_type => res.content_type
  end

  def set_release(release)
    if release == "121"
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

      @releasenotes = _("https://www.suse.com/releasenotes/x86_64/openSUSE/12.1/")
      @releasename = "openSUSE 12.1"
      @repourl = "http://download.opensuse.org/distribution/12.1"
      @medium = "dvd"
      @gpg = "4E98 E675 19D9 8DC7 362A 5990 E3A5 C360 307E 3D54"
    elsif release == "122"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/12.2"
      @isos["lang-32"] = "12.2-Addon-Lang-i586"
      @isos["lang-64"] = "12.2-Addon-Lang-x86_64"
      @isos["nonoss"] = "12.2-Addon-NonOss-BiArch-i586-x86_64"
      @isos["kde-64"] = "12.2-KDE-LiveCD-x86_64"
      @isos["kde-32"] = "12.2-KDE-LiveCD-i686"
      @isos["gnome-64"] = "12.2-GNOME-LiveCD-x86_64"
      @isos["gnome-32"] = "12.2-GNOME-LiveCD-i686"
      @isos["dvd-64"] = "12.2-DVD-x86_64"
      @isos["dvd-32"] = "12.2-DVD-i586"
      @isos["net-32"] = "12.2-NET-i586"
      @isos["net-64"] = "12.2-NET-x86_64"

      @releasenotes = _("https://www.suse.com/releasenotes/x86_64/openSUSE/12.2/")
      @releasename = "openSUSE 12.2"
      @repourl = "http://download.opensuse.org/distribution/12.2"
      @medium = "dvd"
      @gpg = "22C0 7BA5 3417 8CD0 2EFE 22AA B88B 2FD4 3DBD C284"

    elsif release == "developer"
      @isos = {}
      @directory = "http://download.opensuse.org/distribution/12.3-Milestone2"
      @isos["lang-32"] = "Addon-Lang-Build0260-i586"
      @isos["lang-64"] = "Addon-Lang-Build0260-x86_64"
      @isos["nonoss"] = "Addon-NonOss-BiArch-Build0260-i586-x86_64"
      @isos["kde-64"] = "KDE-LiveCD-Build0260-x86_64"
      @isos["kde-32"] = "KDE-LiveCD-Build0260-i686"
      @isos["gnome-64"] = "GNOME-LiveCD-Build0260-x86_64"
      @isos["gnome-32"] = "GNOME-LiveCD-Build0260-i686"
      @isos["dvd-64"] = "DVD-Build0260-x86_64"
      @isos["dvd-32"] = "DVD-Build0260-i586"
      @isos["net-32"] = "NET-Build0260-i586"
      @isos["net-64"] = "NET-Build0260-x86_64"

      @releasenotes = _("https://www.suse.com/releasenotes/x86_64/openSUSE/12.3")
      @releasename = "openSUSE 12.3 Milestone2"
      @repourl = "http://download.opensuse.org/distribution/12.3"
      @medium = "dvd"
      @gpg = "22C0 7BA5 3417 8CD0 2EFE 22AA B88B 2FD4 3DBD C284"
    end
    @release = release
  end

  def redirectit(release)
    if request.user_agent && request.user_agent.index('Mozilla/5.0 (compatible; Konqueror/3')
      notice = _("Konqueror of KDE 3 is unfortunately unmaintained and its javascript implementation contains bugs that " +
          "make it impossible to use with this page. Please make sure you have javascript disabled before you " +
          "<a href='%s'>continue</a>.") % url_for( :action => 'release', :release => release, :locale => FastGettext.locale )
      render :template => "main/redirect_with_notice", :locals => { :notice => notice } and return
    end
    redirect_to :action => 'release', :release => release, :locale => FastGettext.locale
  end


  def developer
    redirectit("developer") and return
    flash.now[:warn] = _("We currently don't have a Factory Snapshot that is more recent than our last openSUSE release. <br/>" +
        "Please check <a href='http://en.opensuse.org/Portal:Factory'>http://en.opensuse.org/Portal:Factory</a> for more information.")
    @exclude_debug = true
    @include_home = 'false'
    set_release("122")
    render :template => "main/release"
  end


  def index
    redirectit("122")
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
