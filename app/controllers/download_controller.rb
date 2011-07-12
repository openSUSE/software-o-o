class DownloadController < ApplicationController

  verify :params => [:prj, :pkg]
  before_filter :prepare

  def prepare
    @prj = params[:prj]
    @pkg = params[:pkg]
    @data = Hash.new

    # add fake data for debug purposes
    ['openSUSE_11.4', 'openSUSE_11.3', 'Fedora_15', 'Fedora_14', 'Mageia_1', 'Mandriva_2011', 'Debian_6.0', 'Ubuntu_11.04', 'CentOS_5', 'RHEL_5', 'SLE_11'].each do |d|
      @data[d] =
        { :repo => "http://download.opensuse.org/repositories/#{@prj}/#{d}/",
          :ymp => "http://software.opensuse.org/ymp/#{@prj}/#{d}/#{@pkg}.ymp",
          :pkg => {
            :i586 => "http://download.opensuse.org/repositories/#{@prj}/#{d}/i586/#{@pkg}-2011.04-1.1.i586.rpm",
            :src => "http://download.opensuse.org/repositories/#{@prj}/#{d}/src/#{@pkg}-2011.04-1.1.src.rpm",
            :x86_64 => "http://download.opensuse.org/repositories/#{@prj}/#{d}/x86_64/#{@pkg}-2011.04-1.1.x86_64.rpm"
          }
        }
    end

    # collect distro types from data
    @distros = @data.keys.collect { |i| i.gsub(/_.*$/, '') }.uniq.sort {|x,y| x.downcase <=> y.downcase }

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
