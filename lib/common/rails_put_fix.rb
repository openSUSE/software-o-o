class CGI #:nodoc:
  module QueryExtension
  private
    def read_put_body(content_length)
      stdinput.binmode if stdinput.respond_to?(:binmode)
      content = stdinput.read(content_length) || ''
      env_table['RAW_POST_DATA'] = content.freeze
    end
    def read_params(method, content_length)
      case method
        when :get
          read_query
        when :post
          read_body(content_length)
        when :put
          read_put_body(content_length)
        when :cmd
          read_from_cmdline
        else # :head, :delete, :options, :trace, :connect
          read_query
      end
    end
  end # module QueryExtension
end

