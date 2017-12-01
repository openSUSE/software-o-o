class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :title, :null => false
      t.string :name, :null => false
      t.string :company
      t.string :street1, :null => false
      t.string :street2
      t.string :zip, :null => false
      t.string :city, :null => false
      t.string :county
      t.string :country, :null => false
      t.string :phone, :null => false
      t.string :email, :null => false
      t.integer :amount, :null => false
      t.text :reason, :null => false
      t.string :deadline, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
