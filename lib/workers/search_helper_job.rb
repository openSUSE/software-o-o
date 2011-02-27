
class SearchHelperJob

  def initialize
  end

  def perform
    c = SearchHelper.new
    c.top_downloads_update
  end

end

