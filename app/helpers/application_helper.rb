# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  @@theme_prefix = nil

  def theme_prefix
    return @@theme_prefix if @@theme_prefix
    @@theme_prefix = '/themes'
    if ActionController::Base.relative_url_root
      @@theme_prefix = ActionController::Base.relative_url_root + @@theme_prefix
    end
    @@theme_prefix
  end

  def compute_asset_host(source)
    if defined? USE_STATIC
      if source.slice(0, theme_prefix.length) == theme_prefix
        return "http://static.opensuse.org"
      end
      return "http://static.opensuse.org/hosts/#{USE_STATIC}"
    end
    super(source)
  end

  def setup_baseproject
    if @baseproject
      scr = "setCookie('search_baseproject','#{@baseproject}');\n"
    else
      scr = "var p = getCookie('search_baseproject'); if (p) { $(\"#baseproject option[value='\" + p + \"']\").attr('selected', 'selected'); }\n"
    end
    "<script type=\"text/javascript\">\n" +
    "//<![CDATA[\n" +
    scr +
    "//]]>\n" +
    "</script>\n"
  end

  def top_downloads
    r = Rails.cache.read('top_downloads')
    # it's possible we will have to enqueue one on cold caches
    Delayed::Job.enqueue SearchHelperJob.new unless r
    return r
  end

end
