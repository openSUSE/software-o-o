
module SearchHelper
  def prepare_desc(desc)
    desc.gsub(/([\w.]+)@([\w.]+)/, '\1 [at] xxx').gsub(/\n/, "<br/>")
  end
end
