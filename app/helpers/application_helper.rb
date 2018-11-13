require 'seeker'

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

  def time_diff time
    Time.now - Time.parse(time)
  end

  def fuzzy_time_string(time)
    return "unknown date" if time.blank?
    return "now" if time_diff(time) < 60
    diff = Integer(time_diff(time) / 60) # now minutes
    return diff.to_s + (diff == 1 ? " min ago" : " mins ago") if diff < 60
    diff = Integer(diff / 60) # now hours
    return diff.to_s + (diff == 1 ? " hour ago" : " hours ago") if diff < 24
    diff = Integer(diff / 24) # now days
    return diff.to_s + (diff == 1 ? " day ago" : " days ago") if diff < 14
    diff = Integer(diff / 7) # now weeks
    return diff.to_s + (diff == 1 ? " week ago" : " weeks ago") if diff < 9
    diff = Integer(diff / 4.1) # roughly months
    return diff.to_s + " months ago" if diff < 24
    diff = Integer(diff / 12) # years
    return diff.to_s + " years ago"
  end

  def escape_for_id string
    string.gsub(/[.:]/, "_")
  end

  # TODO: released projects don't give info over the api... (bnc#749828)
  # so we search one from the other projects...
  def search_for_description(pkgname, packages = [])
    cache_key = "description_package_#{pkgname.downcase}"
    description_package = Rails.cache.fetch(cache_key, :expires_in => 12.hours) do
      if packages.blank?
        packages = OBS.search_published_binary("\"#{pkgname}\"")
        packages.reject! { |p| p.type == 'ymp' }
      end
      packages.select { |p| p.name == pkgname }.each do |package|
        description_package = nil
        unless package.description.blank?
          description_package = package
          logger.info "Found package info for #{pkgname} in: #{package.project}"
          break
        end
        logger.error "No package info for  #{pkgname} in: #{package.project}"
      end
      description_package
    end
  end
end
