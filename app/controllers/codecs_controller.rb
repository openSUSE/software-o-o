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
        @visitor.missing_codecs << MissingCodec.new(a)
        @visitor.application ||= a[2]
      end
    end

  end
end

