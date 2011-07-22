class MissingCodec 
  attr_accessor :description, :framework, :framework_version, :description, :fourcc

  def initialize(a)
    self.framework = a[0]
    self.framework_version = a[1]
    self.description = a[3]
    self.fourcc = Array.new
    self.fourcc << a[4]
  end
  
  def display_framework
    if framework == "gstreamer"
      return "GStreamer"
    else
      return framework.titlecase
    end
  end
end

