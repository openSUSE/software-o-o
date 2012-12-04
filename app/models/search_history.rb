class SearchHistory < ActiveRecord::Base
  attr_accessible :query, :count, :base, :ymp
end
