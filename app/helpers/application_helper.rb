# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  @@theme_prefix = nil

  def theme_prefix
    return @@theme_prefix if @@theme_prefix
    @@theme_prefix = '/themes'
    @@theme_prefix
  end

  def compute_asset_host(source)
    if USE_STATIC and source.slice(0, theme_prefix.length) == theme_prefix
      return "https://static.opensuse.org"
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

end
