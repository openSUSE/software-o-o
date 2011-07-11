class DownloadController < ApplicationController

  verify :params => [:prj, :pkg]
  before_filter :query

  def query
    prj = params[:prj]
    pkg = params[:pkg]
    @data = {'x'=> prj, 'y'=> pkg}
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

  # /download.xml?prj=name&pkg=name
  def xml
    render :xml => @data
  end

end
