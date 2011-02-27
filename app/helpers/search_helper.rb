module SearchHelper
  def shorten_description(text, chars)
    text.sub /^(.{0,#{chars}}\b).*/m, '\1'
  end

  def prepare_desc(desc)
    desc.gsub(/([\w.]+)@([\w.]+)/,'\1 [at] xxx').gsub(/\n/, "<br/>")
  end

  # returns an array of tokens: :prev, :next, :dots or 
  # actual page
  def paginator_list(page_count, current_page)
    range = 3 #show 4 pages around current page
    list = Array.new
    return list if page_count == 1
    
    list << :prev unless current_page == 1

    # add start block unless midrange includes first page
    if current_page > range+1
      1.upto current_page-range-1 do |page|
        if page == range+2
          list << :dots
          break
        end
        list << page
      end
    end

    midstart = current_page-range < 1 ? 1 : current_page-range
    midend = page_count-range < current_page ? page_count : current_page+range
    midstart.upto midend do |page|
      list << page
    end

    list << :dots if midend < page_count-range-1

    if page_count > current_page+range
      (page_count-range).upto page_count do |page|
        next if page <= midend
        list << page
      end
    end

    list << :next if current_page != page_count
    return list
  end

  def default_baseproject
    'openSUSE:11.3'
  end

  def top_downloads
    r = Rails.cache.read('top_downloads')
    
    r = top_downloads_update unless r

    return r
  end

  def top_downloads_update
    time_limit = DateTime.parse 3.months.ago.to_s
    result = ActiveRecord::Base.connection.execute("select query, count(*) as c from download_histories where query is NOT NULL AND created_at > '#{time_limit}' group by query order by c desc limit 15")

    top = Array.new
    result.each do |entry|
      top << { :query => entry[0].strip.downcase, :count => entry[1].to_i}
    end

    Rails.cache.write('top_downloads', top)

    return top
  end

end
