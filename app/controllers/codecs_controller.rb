class CodecsController < ApplicationController
  def index
    @visitor = Visitor.new(
        :os_release => params["os_release"],
        :language => params["lang"],
        :client_version => params["client_version"],
        :kernel => params["kernel"],
        :gstreamer_package => params["gstreamer"],
        :xine_package => params["xine"],
        :user_agent => request.user_agent,
        :ip_address => request.remote_ip
    )

    params.each do | k, v |
      if k.starts_with?("plugin")
        a = v.split("|")
        @visitor.missing_codecs << MissingCodec.from_array(a)
        @visitor.application ||= a[2]
      end
    end

    if @visitor.client_version && @visitor.os_release 
      last_visitor = Visitor.find(
        :first, 
        :include => :missing_codecs,
        :conditions => ['created_at > ? AND ip_address = ? AND missing_codecs.fourcc IN (?)',
          5.minutes.ago, 
          @visitor.ip_address,
          @visitor.missing_codecs.map(&:fourcc)
      ])

      if last_visitor == nil || last_visitor.missing_codecs.length != @visitor.missing_codecs.length 
        @visitor.save()
      end
    end
  end
end

