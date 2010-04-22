class CreateDownloadHistories < ActiveRecord::Migration
  def self.up
    create_table :download_histories do |t|
      t.column :base, :string
      t.column :query, :string
      t.column :file, :string
      t.column :ymp, :string
      t.datetime "created_at"
    end
  end

  def self.down
    drop_table :download_histories
  end
end
