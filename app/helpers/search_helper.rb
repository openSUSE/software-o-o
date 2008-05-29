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
    'openSUSE:10.3'
  end

  def baseproject_list_for_select
    [
      ['openSUSE Factory','openSUSE:Factory'],
      ['openSUSE 11.0','openSUSE:11.0'],
      ['openSUSE 10.3','openSUSE:10.3'],
      ['openSUSE 10.2','openSUSE:10.2'],
      ['SLES/SLED 10','SUSE:SLE-10'],
      ['SLES 9','SUSE:SLES-9'],
      ['Fedora 9','Fedora:9'],
      ['Fedora 8','Fedora:8'],
      ['Fedora 7','Fedora:7'],
      ['RHEL 5','RedHat:RHEL-5'], 
      ['CentOS 5','CentOS:CentOS-5'], 
      ['Mandriva 2008','Mandriva:2008'],
      ['Mandriva 2007','Mandriva:2007'],
      ['Mandriva 2006','Mandriva:2006'],
      ['Debian Etch','Debian:Etch'],
      ['Ubuntu 8.04','Ubuntu:8.04'],
      ['Ubuntu 7.10','Ubuntu:7.10'],
      ['Ubuntu 7.04','Ubuntu:7.04'],
      ['Ubuntu 6.06','Ubuntu:6.06'],
      ['ALL','ALL']
    ]
  end
end
