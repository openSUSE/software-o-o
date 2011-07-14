class DownloadController < ApplicationController

  verify :params => [:prj, :pkg]
  before_filter :prepare

  def prepare
    @prj = params[:prj]
    @pkg = params[:pkg]

    api_result = get_from_api("/search/published/binary/id?match=project='#{@prj}'+and+package='#{@pkg}'")
    if api_result
      @data = Hash.new
      api_result.elements.each("/collection/binary") { |e|
        distro = e.attributes[:repository]
        if not data.has_key?(distro)
          data[distro] = {
            :repo => "http://download.opensuse.org/repositories/#{@prj}/#{distro}/",
            :pkg => Hash.new
          }
          case e.attributes[:baseproject]
            when /^openSUSE:/
              data[distro][:flavor] = 'openSUSE'
              data[distro][:ymp] = "http://software.opensuse.org/ymp/#{@prj}/#{distro}/#{@pkg}.ymp"
            when /^SUSE:SLE-/
              data[distro][:flavor] = 'SLE'
            when /^Fedora:/
              data[distro][:flavor] = 'Fedora'
            when /^RedHat:RHEL-/
              data[distro][:flavor] = 'RHEL'
            when /^CentOS:CentOS-/
              data[distro][:flavor] = 'CentOS'
            when /^Mandriva:/
              data[distro][:flavor] = 'Mandriva'
            when /^Mageia:/
              data[distro][:flavor] = 'Mageia'
            when /^Debian:/
              data[distro][:flavor] = 'Debian'
            when /^Ubuntu:/
              data[distro][:flavor] = 'Ubuntu'
            else
              data[distro][:flavor] = 'Unknown'
          end
        end
        filename = e.attributes[:filename]
        filepath = e.attributes[:filepath]
        data[distro][:pkg][filename] = 'http://download.opensuse.org/repositories/' + filepath
      }
      # collect distro types from data
      @flavors = @data.values.collect { |i| i[:flavor] }.uniq.sort{|x,y| x.downcase <=> y.downcase }
    else
      head :forbidden
    end
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

  private

  def get_from_api(path)
    begin
      req = Net::HTTP::Get.new(path)
      req['x-username'] = ICHAIN_USER
      host, port = API_HOST.split(/:/)
      port ||= 80
      res = Net::HTTP.new(host, port).start do |http|
        http.request(req)
      end
      doc = REXML::Document.new res.body
    rescue
      nil
    end
  end

end
