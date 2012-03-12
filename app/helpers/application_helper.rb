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

  def time_diff time
    Time.now - Time.parse(time)
  end

  def fuzzy_time_string(time)
    return "unknown date" if time.blank?
    return "now" if time_diff(time) < 60
    diff = Integer(time_diff(time)/60) # now minutes
    return diff.to_s + (diff == 1 ? " min ago" : " mins ago") if diff < 60
    diff = Integer(diff/60) # now hours
    return diff.to_s + (diff == 1 ? " hour ago" : " hours ago") if diff < 24
    diff = Integer(diff/24) # now days
    return diff.to_s + (diff == 1 ? " day ago" : " days ago") if diff < 14
    diff = Integer(diff/7) # now weeks
    return diff.to_s + (diff == 1 ? " week ago" : " weeks ago") if diff < 9
    diff = Integer(diff/4.1) # roughly months
    return diff.to_s + " months ago"  if diff < 24
    diff = Integer(diff/12) # years
    return diff.to_s + " years ago"
  end

  def escape_for_id string
    string.gsub(/[.:]/, "_")
  end

end

module Enumerable
  def version_sort
    sort_by { |key,val|
       key.gsub(/_SP/, '.') \
          .gsub(/_Factory/, '_100') \
          .gsub(/_Tumbleweed/, '_99') \
          .split(/_/) \
          .map { |v| v =~ /\A\d+(\.\d+)?\z/ ? -(v.to_f) : v.downcase }
    }
  end
end
