module PackageHelper
  def human_arch arch
    case arch
    when ("i586") then
      "32 Bit"
    when ("i386") then
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
    text.length > chars ? text[0, chars - 2] + "..." : text
  end

  def prepare_desc txt
    txt = txt.gsub(/[\n][\n]+/, "\n\n")
    txt = create_links txt
    txt = txt.sub(/Authors[:]?[\w\W]+/, "")
    txt
  end

  def create_links(txt)
    txt = txt.gsub(/(https?:\/\/[-_A-Za-z0-9\/\(\)\[\]:,.;?&+@#%=~|]+[^),. <"'\n\r])/m, '<a href="\1">\1</a> ')
    txt
  end

  # Returns the screenshot thumbnail url for a given package object/hash
  def screenshot_thumb_url(package)
    url_for :controller => :package, :action => :thumbnail, :package => package, protocol: 'https'
  end
end
