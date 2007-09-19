class MissingCodec < ActiveRecord::Base
  belongs_to :visitor
  attr_accessor :description
  validates_inclusion_of :framework, :in => ['gstreamer', 'xine']

  def self.from_array(a)
    new(:framework => a[0],
        :framework_version => a[1],
        :description => a[3],
        :fourcc => a[4])
  end
  
  def display_framework
    if framework == "gstreamer"
      return "GStreamer"
    else
      return framework.titlecase
    end
  end
end

