class DownloadController < ApplicationController

  before_filter :prepare

  def index
    if @package
      @page_title = _("Install package %s / %s") % [@project, @package]
    else
      @page_title = _("Install pattern %s / %s") % [@project, @pattern]
    end
    @box_title  = @page_title
    @hide_search_box = true
    render :html, :layout => 'download'
  end

  # /download.html?project=name&package=name
  # /download.html?project=name&pattern=name
  def iframe
    if params[:acolor]
      raise "Invalid acolor value (has to be 000-fff)" unless params[:acolor] =~ /^[0-9a-f]{3}([0-9a-f]{3})?$/
      @acolor = '#' + params[:acolor]
    end
    if params[:bcolor]
      raise "Invalid bcolor value (has to be 000-fff)" unless params[:bcolor] =~ /^[0-9a-f]{3}([0-9a-f]{3})?$/
      @bcolor = '#' + params[:bcolor]
    end
    if params[:fcolor]
      raise "Invalid fcolor value (has to be 000-fff)" unless params[:fcolor] =~ /^[0-9a-f]{3}([0-9a-f]{3})?$/
      @fcolor = '#' + params[:fcolor]
    end
    if params[:hcolor]
      raise "Invalid hcolor value (has to be 000-fff)" unless params[:hcolor] =~ /^[0-9a-f]{3}([0-9a-f]{3})?$/
      @hcolor = '#' + params[:hcolor]
    end
    render :html, :layout => 'iframe'
  end

  # /download.json?project=name&package=name
  # /download.json?project=name&pattern=name
  def json
    # needed for rails < 3.0 to support JSONP
    render_json @data.to_json
  end

  private

  def prepare
    required_parameters :project
    raise "Invalid project name" unless valid_project_name? params[:project]
    raise "Invalid package name" unless params[:package].nil? or valid_package_name? params[:package]
    raise "Invalid pattern name" unless params[:pattern].nil? or valid_pattern_name? params[:pattern]
    @project = params[:project]
    @package = params[:package]
    @pattern = params[:pattern]
    raise "Provide package or pattern parameter" if @package.nil? and @pattern.nil?
    cache_key = "soo_download_#{@project}_#{@package}_#{@pattern}"

    @data = Rails.cache.fetch(cache_key, :expires_in => 2.hours) do
      if not @package.nil?
        api_result = get_from_api("/search/published/binary/id?match=project='#{@project}'+and+package='#{@package}'")
        xpath = "/collection/binary"
      else
#        api_result = get_from_api("/search/published/pattern/id?match=project='#{@project}'+and+filename='#{@pattern}.ymp'")
# TODO: workaround - the line above does not return a thing - see http://lists.opensuse.org/opensuse-buildservice/2011-07/msg00088.html
        api_result = get_from_api("/search/published/pattern/id?match=project='#{@project}'")
# END
        xpath = "/collection/pattern"
      end
      if api_result
        doc = REXML::Document.new api_result.body
        data = Hash.new
        doc.elements.each(xpath) { |e|
# TODO: workaround - filter by filename here - see comment few lines above for explanation
          next if not @pattern.nil? and e.attributes['filename'] != "#{@pattern}.ymp"
# END
          distro = e.attributes['repository']
          if not data.has_key?(distro)
            data[distro] = {
              :repo => "http://download.opensuse.org/repositories/#{@project}/#{distro}/",
              :package => Hash.new
            }
            case e.attributes['baseproject']
              when /^(DISCONTINUED:)?openSUSE:/
                data[distro][:flavor] = 'openSUSE'
                if not @package.nil?
                  data[distro][:ymp] = "http://software.opensuse.org/ymp/#{@project}/#{distro}/#{@package}.ymp"
                else
                  data[distro][:ymp] = "http://download.opensuse.org/repositories/" + e.attributes['filepath']
                end
              when /^(DISCONTINUED:)?SUSE:SLE-/
                data[distro][:flavor] = 'SLE'
                if not @package.nil?
                  data[distro][:ymp] = "http://software.opensuse.org/ymp/#{@project}/#{distro}/#{@package}.ymp"
                else
                  data[distro][:ymp] = "http://download.opensuse.org/repositories/" + e.attributes['filepath']
                end
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
          if not @package.nil?
            filename = e.attributes['filename']
            filepath = e.attributes['filepath']
            data[distro][:package][filename] = 'http://download.opensuse.org/repositories/' + filepath
          end
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

end
