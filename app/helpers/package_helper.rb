module PackageHelper
  
  def human_arch(arch)
    case arch
    when ( "i586" ) then 
      "32 Bit"
    when ( "i386" ) then
      "32 Bit"
    when ("x86_64") then 
      "64 Bit"
    when ("amd64") then
      "64 Bit"
    when ("src") then 
      _("Source")
    when ("nosrc") then
      _("Source")
    else
      arch
    end
  end

  def shorten(text, chars)
    text.length > chars ? text[0,chars-2] + "..." : text
  end

  def prepare_desc(txt)
    txt = txt.gsub(/[\n][\n]+/, "\n\n")
    txt = create_links txt
    txt = txt.sub(/Authors[:]?[\w\W]+/, "")
    txt
  end

  def create_links (txt)
    txt = txt.gsub(/(https?:\/\/[-_A-Za-z0-9\/\(\)\[\]:,.;?&+@#%=~|]+[^),. <"'\n\r])/m, '<a href="\1">\1</a> ')
    txt
  end

  def screenshot_thumb_url(pkg_name, source_url)
    screenshot = Screenshot.new(pkg_name, source_url)
    # Don't wait for every thumbnail to be generated before loading the page.
    path = screenshot.thumbnail_path(fetch: false)
    if path
      image_url path
    else
      # If a thumbnail is not already generated, do it in separate request.
      url_for controller: :package, action: :thumbnail, package: pkg_name, appscreen: source_url
    end
  end
end
