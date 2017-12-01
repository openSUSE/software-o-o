class AddOrderConfirmation < ActiveRecord::Migration
  def self.up
    add_column :orders, :processed_at, :datetime
    add_column :orders, :processed_by, :string
  end

  def self.down
    remove_column :orders, :processed_at
    remove_column :orders, :processed_by
  end
end
