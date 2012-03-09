#
# method copied from rails3 MemCacheStore
#

module ActiveSupport

  class Cache::CompressedMemCacheStore
    def escape_key(key)
      key = key.to_s.gsub(/[\x00-\x20%\x7F-\xFF]/, '_')
      key = "#{key[0, 213]}:md5:#{Digest::MD5.hexdigest(key)}" if key.size > 250
      key
    end
  end
end

