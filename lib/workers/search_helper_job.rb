class SearchHelperJob

  def initialize
  end

  #fill the cache for top_downloads
  def perform
    time_limit = DateTime.parse 3.months.ago.to_s
    result = ActiveRecord::Base.connection.execute("select query, count(*) as c from download_histories where query is NOT NULL " +
        "AND created_at > '#{time_limit}' group by query order by c desc limit 15")
    top = result.map{|entry| { :query => entry[0].strip.downcase, :count => entry[1].to_i} }
    puts "Writing to top_downloads cache: " + top.inspect
    Rails.cache.write('top_downloads', top)
    return top
  end

end

