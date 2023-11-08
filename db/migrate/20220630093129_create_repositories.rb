class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :url
      t.boolean :updateinfo, default: false
      t.string :revision
      t.references :distribution

      t.timestamps
    end
  end
end
