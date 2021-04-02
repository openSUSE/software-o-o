# frozen_string_literal: true

module PackageHelper
  def human_arch(arch)
    case arch
    when 'i586'
      '32 Bit'
    when 'i386'
      '32 Bit'
    when 'x86_64'
      '64 Bit'
    when 'amd64'
      '64 Bit'
    when 'src'
      _('Source')
    when 'nosrc'
      _('Source')
    else
      arch
    end
  end

  def shorten(text, chars)
    text.length > chars ? "#{text[0, chars - 2]}..." : text
  end

  def prepare_desc(txt)
    return if txt.blank?

    txt = txt.gsub(/\n\n+/, "\n\n")
    txt = create_links txt
    txt.sub(/Authors:?[\w\W]+/, '')
  end

  def create_links(txt)
    txt.gsub(%r{(https?://[-_A-Za-z0-9/()\[\]:,.;?&+@#%=~|]+[^),. <"'\n\r])}m, '<a href="\1">\1</a> ')
  end

  # Returns the screenshot thumbnail url for a given package object/hash
  def screenshot_thumb_url(package)
    url_for controller: :package, action: :thumbnail, package: package, protocol: 'https'
  end

  def project_url(project)
    "<a href='#{Rails.configuration.x.web_host}/project/show/#{project}'>#{project}</a>"
  end
end
