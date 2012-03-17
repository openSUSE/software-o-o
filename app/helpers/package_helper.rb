module PackageHelper
  
  def human_arch arch
    case arch
    when ( "i586" || "i386" ) then 
      "32 Bit"
    when ("x86_64" || "amd64") then 
      "64 Bit"
    when ("src" || "nosrc") then 
      "Source"
    else
      arch
    end
  end

  def shorten(text, chars)
    text.length > chars ? text[0,chars] + "..." : text
  end

  def prepare_desc txt
    txt = txt.gsub(/[\n][\n]+/, "\n\n")
    txt = create_links txt
    txt
  end

  def create_links (txt)
    txt = txt.gsub(/(https?:\/\/[-_A-Za-z0-9\/\(\)\[\]:,.;?&+@#%=~|]+[^),. <"'\n\r])/m, '<a href="\1">\1</a> ')
    txt
  end

  def screenshot_thumb_url pkgname
    case pkgname
    when /-devel$/
      screenshot_thumb =  image_path "file_settings.png"
    when /-debug$/
      screenshot_thumb = image_path "file_settings.png"
    when /-doc$/
      screenshot_thumb = image_path "file_settings.png"
    when /-javadoc$/
      screenshot_thumb = image_path "file_settings.png"
    when /-debuginfo$/
      screenshot_thumb = image_path "file_settings.png"
    when /-debugsource$/
      screenshot_thumb = image_path "file_settings.png"
    else
      screenshot_thumb = "http://screenshots.debian.net/thumbnail/" + pkgname.downcase
    end
    screenshot_thumb
  end



end
