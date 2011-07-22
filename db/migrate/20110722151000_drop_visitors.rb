class DropVisitors < ActiveRecord::Migration
  def self.up
    drop_table :missing_codecs
    drop_table :visitors
  end

  def self.down
    raise IrreversibleMigration
  end
end
