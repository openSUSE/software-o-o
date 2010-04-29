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
    'openSUSE:11.2'
  end


  def baseproject_list_for_select
    [
      ['openSUSE Factory','openSUSE:Factory'],
      ['openSUSE 11.2','openSUSE:11.2'],
      ['openSUSE 11.1','openSUSE:11.1'],
      ['openSUSE 11.0','openSUSE:11.0'],
      ['SLES/SLED 11','SUSE:SLE-11'],
      ['SLES/SLED 10','SUSE:SLE-10'],
      ['SLES 9','SUSE:SLES-9'],
      ['Fedora 13','Fedora:13'],
      ['Fedora 12','Fedora:12'],
      ['Fedora 11','Fedora:11'],
      ['Fedora 10','Fedora:10'],
      ['RHEL 5','RedHat:RHEL-5'],
      ['RHEL 4','RedHat:RHEL-4'],
      ['CentOS 5','CentOS:CentOS-5'],
      ['Mandriva 2010','Mandriva:2010'],
      ['Mandriva 2009.1','Mandriva:2009.1'],
      ['Mandriva 2009','Mandriva:2009'],
      ['Debian 5.0 (Lenny)','Debian:5.0'],
      ['Debian 4.0 (Etch)','Debian:Etch'],
      ['Ubuntu 10.04','Ubuntu:10.04'],
      ['Ubuntu 9.10','Ubuntu:9.10'],
      ['Ubuntu 9.04','Ubuntu:9.04'],
      ['Ubuntu 8.04','Ubuntu:8.04'],
      ['Ubuntu 6.06','Ubuntu:6.06'],
      ['ALL','ALL']
    ]
  end

  def top_downloads
    Rails.cache.fetch('top_downloads', :expires_in => 12.hours) do
      list=DownloadHistory.find :all, :conditions => "query IS NOT NULL"
      queries=Hash.new
      list.each do |s|
        s = s.query.strip.downcase
        queries[s] ||= 0
        queries[s] += 1
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
