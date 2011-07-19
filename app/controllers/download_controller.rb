class DownloadController < ApplicationController

  verify :params => [:prj, :pkg]
  before_filter :prepare

  def prepare
    @prj = params[:prj]
    @pkg = params[:pkg]
    cache_key = "soo_download_#{@prj}_#{@pkg}"

    @data = Rails.cache.fetch(cache_key, :expires_in => 2.hours) do
      api_result = get_from_api("/search/published/binary/id?match=project='#{@prj}'+and+package='#{@pkg}'")
      if api_result
        doc = REXML::Document.new api_result.body
        data = Hash.new
        doc.elements.each("/collection/binary") { |e|
          distro = e.attributes['repository']
          if not data.has_key?(distro)
            data[distro] = {
              :repo => "http://download.opensuse.org/repositories/#{@prj}/#{distro}/",
              :pkg => Hash.new
            }
            case e.attributes['baseproject']
              when /^(DISCONTINUED:)?openSUSE:/
                data[distro][:flavor] = 'openSUSE'
                data[distro][:ymp] = "http://software.opensuse.org/ymp/#{@prj}/#{distro}/#{@pkg}.ymp"
              when /^(DISCONTINUED:)?SUSE:SLE-/
                data[distro][:flavor] = 'SLE'
                data[distro][:ymp] = "http://software.opensuse.org/ymp/#{@prj}/#{distro}/#{@pkg}.ymp"
              when /^(DISCONTINUED:)?Fedora:/
                data[distro][:flavor] = 'Fedora'
              when /^(DISCONTINUED:)?RedHat:RHEL-/
                data[distro][:flavor] = 'RHEL'
              when /^(DISCONTINUED:)?ScientificLinux:/
                data[distro][:flavor] = 'SL'
              when /^(DISCONTINUED:)?CentOS:CentOS-/
                data[distro][:flavor] = 'CentOS'
              when /^(DISCONTINUED:)?Mandriva:/
                data[distro][:flavor] = 'Mandriva'
              when /^(DISCONTINUED:)?Mageia:/
                data[distro][:flavor] = 'Mageia'
              when /^(DISCONTINUED:)?Debian:/
                data[distro][:flavor] = 'Debian'
              when /^(DISCONTINUED:)?Ubuntu:/
                data[distro][:flavor] = 'Ubuntu'
              else
                data[distro][:flavor] = 'Unknown'
            end
          end
          filename = e.attributes['filename']
          filepath = e.attributes['filepath']
          data[distro][:pkg][filename] = 'http://download.opensuse.org/repositories/' + filepath
        }
        data
      else
        nil
      end
    end

    if @data.nil?
      head :forbidden
    else
      # collect distro types from @data
      @flavors = @data.values.collect { |i| i[:flavor] }.uniq.sort{|x,y| x.downcase <=> y.downcase }
    end
  end

  # /download.html?prj=name&pkg=name
  def html
    render :html, :layout => false
  end

  # /download.json?prj=name&pkg=name
  def json
    # needed for rails < 3.0 to support JSONP
    render_json @data.to_json
  end

end
