class DownloadController < ApplicationController
  before_action :set_colors

  # display documentation
  def doc
  end

  def appliance
    required_parameters :project
    @project = params[:project]
    # TODO: no clear way to fetch appliances. we need a /search/published/appliance

    cache_key = "soo_download_appliances_#{@project}"
    @data = Rails.cache.fetch(cache_key, :expires_in => 10.minutes) do
      api_result_images = ApiConnect::get("/published/#{@project}/images")
      api_result_iso = ApiConnect::get("/published/#{@project}/images/iso")
      xpath = "/directory/entry"
      if api_result_images
        doc = REXML::Document.new api_result_images.body
        data = Hash.new
        doc.elements.each(xpath) do |e|
          filename = e.attributes['name']
          ext = ['.bz2', '.xz', '.qcow2', '.vdi', '.vmdk', '.vmx', '.ova']
          if ext.include? File.extname(filename)
            data[filename] = { :flavor => get_image_type(filename) }
          end
        end
        if api_result_iso
          dociso = REXML::Document.new api_result_iso.body
          dociso.elements.each(xpath) do |e|
            filename = e.attributes['name']
            if File.extname(filename) == '.iso'
              data[filename] = { :flavor => get_image_type(filename) }
            end
          end
        end
        data
      else
        nil
      end
    end
    set_flavours
    @page_title = _("Download appliance from %s") % [@project]
    render_page :appliance
  end

  def package
    redirect_to :action => :doc and return if !params[:project] && !params[:package]
    required_parameters :project, :package
    @project = params[:project]
    @package = params[:package]
    escaped_prj = CGI.escape(@project)
    escaped_pkg = CGI.escape(@package)

    cache_key = "soo_download_#{@project}_#{@package}"
    @data = Rails.cache.fetch(cache_key, :expires_in => 10.minutes) do
      api_result = ApiConnect::get("/search/published/binary/id?match=project='#{escaped_prj}'+and+name='#{escaped_pkg}'")
      xpath = "/collection/binary"
      if api_result
        doc = REXML::Document.new api_result.body
        data = Hash.new
        doc.elements.each(xpath) do |e|
          distro = e.attributes['repository']
          if not data.has_key?(distro)
            data[distro] = {
              :repo => "https://download.opensuse.org/repositories/#{@project}/#{distro}/",
              :package => Hash.new
            }
            data[distro][:flavor] = set_distro_flavor e.attributes['baseproject']
            case e.attributes['baseproject']
            when /^(DISCONTINUED:)?openSUSE:/, /^(DISCONTINUED:)?SUSE:SLE-/
              data[distro][:ymp] = "https://software.opensuse.org/ymp/#{@project}/#{distro}/#{@package}.ymp"
            end
          end
          filename = e.attributes['filename']
          filepath = e.attributes['filepath']
          data[distro][:package][filename] = 'https://download.opensuse.org/repositories/' + filepath
        end
        data
      else
        nil
      end
    end
    set_flavours
    @page_title = _("Install package %s / %s") % [@project, @package]
    render_page :package
  end

  def pattern
    required_parameters :project, :pattern
    @project = params[:project]
    @pattern = params[:pattern]

    cache_key = "soo_download_#{@project}_#{@pattern}"
    @data = Rails.cache.fetch(cache_key, :expires_in => 10.minutes) do
      # api_result = ApiConnect::get("/search/published/pattern/id?match=project='#{@project}'+and+filename='#{@pattern}.ymp'")
      # TODO: workaround - the line above does not return a thing - see https://lists.opensuse.org/opensuse-buildservice/2011-07/msg00088.html
      # so we search for all files of the project and filter for *.ymp below
      api_result = ApiConnect::get("/search/published/pattern/id?match=project='#{@project}'")
      xpath = "/collection/pattern"
      # logger.debug doc

      if api_result
        doc = REXML::Document.new api_result.body
        data = Hash.new
        doc.elements.each(xpath) do |e|
          next if e.attributes['filename'] != "#{@pattern}.ymp"
          distro = e.attributes['repository']
          if not data.has_key?(distro)
            data[distro] = {
              :repo => "https://download.opensuse.org/repositories/#{@project}/#{distro}/",
              :package => Hash.new
            }
            data[distro][:flavor] = set_distro_flavor e.attributes['baseproject']
            case e.attributes['baseproject']
            when /^(DISCONTINUED:)?openSUSE:/, /^(DISCONTINUED:)?SUSE:SLE-/
              data[distro][:ymp] = "https://download.opensuse.org/repositories/" + e.attributes['filepath']
            end
          end
        end
        data
      else
        nil
      end
    end
    set_flavours
    @page_title = _("Install pattern %s / %s") % [@project, @pattern]
    render_page :package
  end

  def ymp_with_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:arch]}/#{params[:binary]}?view=ymp"
    res = Rails.cache.fetch("ymp_#{path}", :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :body => res.body, :content_type => res.content_type
  end

  def ymp_without_arch_and_version
    path = "/published/#{params[:project]}/#{params[:repository]}/#{params[:package]}?view=ymp"
    res = Rails.cache.fetch("ymp_#{path}", :expires_in => 1.hour) do
      ApiConnect::get(path)
    end
    render :body => res.body, :content_type => res.content_type
  end

  private

  def set_parameters
    @hide_search_box = true
  end

  def render_page page_template
    @box_title = @page_title
    respond_to do |format|
      format.html { render page_template, :layout => 'download' }
      format.iframe {
        response.headers.except! 'X-Frame-Options'
        render page_template, :layout => 'iframe.html'
      }
      # needed for rails < 3.0 to support JSONP
      format.json { render_json @data.to_json }
    end
  end

  def set_distro_flavor distro
    case distro
    when /^(DISCONTINUED:)?openSUSE:/
      'openSUSE'
    when /^(DISCONTINUED:)?SUSE:SLE-/
      'SLE'
    when /^(DISCONTINUED:)?Fedora:/
      'Fedora'
    when /^(DISCONTINUED:)?RedHat:RHEL-/
      'RHEL'
    when /^(DISCONTINUED:)?ScientificLinux:/
      'SL'
    when /^(DISCONTINUED:)?CentOS:CentOS-/
      'CentOS'
    when /^(DISCONTINUED:)?Mandriva:/
      'Mandriva'
    when /^(DISCONTINUED:)?Mageia:/
      'Mageia'
    when /^(DISCONTINUED:)?Debian:/
      'Debian'
    when /^(DISCONTINUED:)?Ubuntu:/
      'Ubuntu'
    when /^Univention:/
      'Univention'
    when /^Arch:/
      'Arch'
    when /AppImage/
      'AppImage'
    else
      'Unknown'
    end
  end

  def set_flavours
    if @data.nil?
      head :forbidden
    else
      # collect distro types from @data
      @flavors = @data.values.collect { |i| i[:flavor] }.uniq.sort { |x, y| x.downcase <=> y.downcase }
    end
  end

  def get_image_type filename
    case filename
    when /raw\.bz2$/, /raw\.tar\.bz2$/, /raw\.xz$/
      'Raw'
    when /vmx\.tar\.bz2$/, /\.vmdk$/, /\.vmx$/
      'VMWare'
    when /pxe\.tar\.bz2$/
      'PXE'
    when /lxc\.tar\.bz2$/
      'LXC'
    when /\.qcow2$/
      'QEMU'
    when /\.vdi$/
      'VirtualBox'
    when /\.iso$/
      'ISO'
    when /\.ova$/
      'OVA'
    when /docker/
      'Docker'
    else
      'Unknown'
    end
  end

  def set_colors
    if params[:acolor]
      raise "Invalid acolor value (has to be 000-fff or 000000-ffffff)" unless valid_color? params[:acolor]
      @acolor = '#' + params[:acolor]
    end
    if params[:bcolor]
      raise "Invalid bcolor value (has to be 000-fff or 000000-ffffff)" unless valid_color? params[:bcolor]
      @bcolor = '#' + params[:bcolor]
    end
    if params[:fcolor]
      raise "Invalid fcolor value (has to be 000-fff or 000000-ffffff)" unless valid_color? params[:fcolor]
      @fcolor = '#' + params[:fcolor]
    end
    if params[:hcolor]
      raise "Invalid hcolor value (has to be 000-fff or 000000-ffffff)" unless valid_color? params[:hcolor]
      @hcolor = '#' + params[:hcolor]
    end
  end

  def valid_color? color
    color =~ /^[0-9a-fA-F]{3}([0-9a-fA-F]{3})?$/
  end
end
