class CreatePatches < ActiveRecord::Migration[7.1]
  def change
    create_table :patches do |t|
      t.string :name
      t.string :kind
      t.integer :status
      t.string :title
      t.string :severity
      t.text :description
      t.references :package

      t.timestamps
    end
  end
end
