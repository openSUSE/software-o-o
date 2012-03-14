class StatisticController < ApplicationController

  TIME_LIMIT = DateTime.parse 3.months.ago.to_s

  def index
    @top_searches = top_searches
    @failed_searches = failed_searches
  end


  private

  def top_searches
    Rails.cache.fetch('top_searches', :expires_in => 2.hours) do
      result = ActiveRecord::Base.connection.execute("select query, count(*) as c from search_histories where query is NOT NULL " +
          "AND count > 0 AND created_at > '#{TIME_LIMIT}' group by query order by c desc limit 15;")
      result.map{|entry| { :query => entry[0].strip.downcase, :count => entry[1].to_i} }
    end
  end


  def failed_searches
    Rails.cache.fetch('failed_searches', :expires_in => 2.hours) do
      result = ActiveRecord::Base.connection.execute("select query, count(*) as c from search_histories where query is NOT NULL " +
          "AND count = 0 AND created_at > '#{TIME_LIMIT}' group by query order by c desc limit 15; ")
      result.map{|entry| { :query => entry[0].strip.downcase, :count => entry[1].to_i} }
    end
  end

end
