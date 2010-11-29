
desc "Remove old download and search stats"
task(:clean_stats => :environment) do

  limit_search = DateTime.parse 1.year.ago.to_s
  limit_download = DateTime.parse 1.year.ago.to_s

  SearchHistory.connection.execute("delete from download_histories where created_at < '#{limit_download}'")
  SearchHistory.connection.execute("delete from search_histories where created_at < '#{limit_search}'")

end
