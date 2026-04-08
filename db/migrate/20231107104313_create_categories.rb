class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :categories_packages, id: false do |t|
      t.belongs_to :category
      t.belongs_to :package
    end
  end
end
