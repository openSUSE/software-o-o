class DownloadController < ApplicationController

  verify :params => [:prj, :pkg]
  before_filter :prepare

  # generates fake data
  def fake_data(data, prj, pkg, flavor, distro, format)
    data[distro] = { :flavor => flavor,
      :repo => "http://download.opensuse.org/repositories/#{prj}/#{distro}/",
      :ymp => "http://software.opensuse.org/ymp/#{prj}/#{distro}/#{pkg}.ymp",
      :pkg => {
        :i586 => "http://download.opensuse.org/repositories/#{prj}/#{distro}/i586/#{pkg}-2011.04-1.1.i586.#{format}",
        :src => "http://download.opensuse.org/repositories/#{prj}/#{distro}/src/#{pkg}-2011.04-1.1.src.#{format}",
        :x86_64 => "http://download.opensuse.org/repositories/#{prj}/#{distro}/x86_64/#{pkg}-2011.04-1.1.x86_64.#{format}"
      }
    }
  end

  def prepare
    @prj = params[:prj]
    @pkg = params[:pkg]
    @data = Hash.new

    # add fake data for debug purposes
    fake_data(@data, @prj, @pkg, 'openSUSE', 'openSUSE_11.4', 'rpm')
    fake_data(@data, @prj, @pkg, 'openSUSE', 'openSUSE_11.3', 'rpm')
    fake_data(@data, @prj, @pkg, 'openSUSE', 'KDE_Distro_Stable_openSUSE_11.3', 'rpm')
    fake_data(@data, @prj, @pkg, 'openSUSE', 'KR46_11.4', 'rpm')
    fake_data(@data, @prj, @pkg, 'Fedora', 'Fedora_15', 'rpm')
    fake_data(@data, @prj, @pkg, 'Fedora', 'Fedora_14', 'rpm')
    fake_data(@data, @prj, @pkg, 'Mageia', 'Mageia_1', 'rpm')
    fake_data(@data, @prj, @pkg, 'Mandriva', 'Mandriva_2011', 'rpm')
    fake_data(@data, @prj, @pkg, 'Debian', 'Debian_6.0', 'deb')
    fake_data(@data, @prj, @pkg, 'Ubuntu', 'Ubuntu_11.04', 'deb')
    fake_data(@data, @prj, @pkg, 'CentOS', 'CentOS_5', 'rpm')
    fake_data(@data, @prj, @pkg, 'RHEL', 'RHEL_5', 'rpm')
    fake_data(@data, @prj, @pkg, 'SLE', 'SLE_11', 'rpm')

    # collect distro types from data
    @flavors = @data.values.collect { |i| i[:flavor] }.uniq.sort{|x,y| x.downcase <=> y.downcase }

  end

  # /download.html?prj=name&pkg=name
  def html
    render :html, :layout => false
  end

  # /download.js?prj=name&pkg=name
  def js
    render :js, :layout => false
  end

  # /download.json?prj=name&pkg=name
  def json
    # needed for rails < 3.0 to support JSONP
    render_json @data.to_json
  end

end
