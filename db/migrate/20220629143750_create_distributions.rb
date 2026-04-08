class CreateDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :distributions do |t|
      t.string :name
      t.string :url
      t.string :obs_repo_names

      t.timestamps
    end
  end
end
