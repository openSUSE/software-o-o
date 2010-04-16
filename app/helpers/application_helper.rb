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

end
