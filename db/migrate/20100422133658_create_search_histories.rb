class CreateSearchHistories < ActiveRecord::Migration
  def self.up
    create_table :search_histories do |t|
      t.column :base, :string
      t.column :query, :string
      t.column :count, :integer
      t.column :binaries, :integer
      t.column :patterns, :integer
      t.datetime "created_at"
    end
  end

  def self.down
    drop_table :search_histories
  end
end
