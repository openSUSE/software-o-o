class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :release
      t.string :architectures
      t.string :license
      t.string :url
      t.string :title
      t.string :summary
      t.text :description
      t.integer :weight, default: 100
      t.boolean :appstream, default: false
      t.references :repository

      t.timestamps
    end
  end
end
