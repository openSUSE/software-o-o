class CreateIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :issues do |t|
      t.text :href
      t.string :name
      t.string :title
      t.string :kind
      t.references :patch

      t.timestamps
    end
  end
end
