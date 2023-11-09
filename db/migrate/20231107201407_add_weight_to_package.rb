class AddWeightToPackage < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :weight, :integer, default: 100
  end
end
