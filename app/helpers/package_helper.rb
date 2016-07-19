module PackageHelper
  
  def human_arch arch
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

  def prepare_desc txt
    txt = txt.gsub(/[\n][\n]+/, "\n\n")
    txt = create_links txt
    txt = txt.sub(/Authors[:]?[\w\W]+/, "")
    txt
  end

  def create_links (txt)
    txt = txt.gsub(/(https?:\/\/[-_A-Za-z0-9\/\(\)\[\]:,.;?&+@#%=~|]+[^),. <"'\n\r])/m, '<a href="\1">\1</a> ')
    txt
  end

  def screenshot_thumb_url pkgname
    case pkgname
    when /-devel$/
      screenshot_thumb =  image_path "default-screenshots/file_settings.png"
    when /-devel-/
      screenshot_thumb =  image_path "default-screenshots/file_settings.png"
    when /-lang$/
      screenshot_thumb =  image_path "default-screenshots/file_settings.png"
    when /-debug$/
      screenshot_thumb = image_path "default-screenshots/file_settings.png"
    when /-doc$/
      screenshot_thumb = image_path "default-screenshots/files.png"
    when /-help-/
      screenshot_thumb = image_path "default-screenshots/files.png"
    when /-javadoc$/
      screenshot_thumb = image_path "default-screenshots/files.png"
    when /-debuginfo/
      screenshot_thumb = image_path "default-screenshots/file_settings.png"
    when /-debugsource/
      screenshot_thumb = image_path "default-screenshots/file_settings.png"
    when /-kmp-/
      screenshot_thumb = image_path "default-screenshots/file_settings.png"
    when /^rubygem-/
      screenshot_thumb = image_path "default-screenshots/rubygem.png"
    when /^perl-/
      screenshot_thumb = image_path "default-screenshots/perl.gif"
    when /^python-/
      screenshot_thumb = image_path "default-screenshots/python.png"
    when /^kernel-/
      screenshot_thumb = image_path "default-screenshots/tux.png"
    when /^openstack-/i
      screenshot_thumb = image_path "default-screenshots/openstack.png"
    else
      screenshot_thumb = image_path "default-screenshots/no_screenshot_opensuse.png"
    end
    screenshot_thumb
  end



end
