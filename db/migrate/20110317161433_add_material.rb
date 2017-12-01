class AddMaterial < ActiveRecord::Migration
  def self.up
    add_column :orders, :material, :string
  end

  def self.down
    remove_column :orders, :material
  end
end

