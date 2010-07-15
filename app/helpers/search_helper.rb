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
    Rails.cache.fetch('top_downloads', :expires_in => 12.hours) do
      list=ActiveRecord::Base.connection.execute('select query, count(*) as c from download_histories where query is NOT NULL group by query order by c desc limit 200;')
      queries=Hash.new
      list.each do |entry|
        s = entry[0].strip.downcase
        queries[s] ||= 0
        queries[s] += entry[1].to_i
      end

      queries = queries.to_a.sort { |x,y| y[1] <=> x[1] }
      tops = Array.new
      count = 0
      queries.each do |q,c|
        tops << { :query => q, :count => c}
        break if count > 15
        count += 1
      end
      tops
    end
  end
end
