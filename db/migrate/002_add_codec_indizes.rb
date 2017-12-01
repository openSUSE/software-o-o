class AddCodecIndizes < ActiveRecord::Migration
  def self.up
    add_index :missing_codecs, [:visitor_id], :name => "visitor_id_index"
    add_index :missing_codecs, [:fourcc], :name => "fourcc_index"
    add_index :visitors, [:created_at], :name => "created_at_index"
    add_index :visitors, [:ip_address], :name => "ip_address_index"
  end

  def self.down
    remove_index :missing_codecs, :name => "visitor_id_index"
    remove_index :missing_codecs, :name => "fourcc_index"
    remove_index :visitors, :name => "created_at_index"
    remove_index :visitors, :name => "ip_address_index"
  end
end
