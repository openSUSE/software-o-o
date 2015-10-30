class DropSearchHistories < ActiveRecord::Migration
  def change
    drop_table :search_histories
  end
end
