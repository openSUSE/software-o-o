class CodecsController < ApplicationController 
  def index
    @missing_codecs = []
    @application = nil

    params.each do | k, v |
      if k.starts_with?("plugin")
        m = MissingCodec.new(v.split("|"))
        @missing_codecs << m
        if @application == nil
          @application = m.application
        end
      end
    end
  end
end

