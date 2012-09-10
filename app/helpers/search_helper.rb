
module SearchHelper

  def prepare_desc(desc)
    desc.gsub(/([\w.]+)@([\w.]+)/,'\1 [at] xxx').gsub(/\n/, "<br/>")
  end

  def default_baseproject
    'openSUSE:12.2'
  end

end
