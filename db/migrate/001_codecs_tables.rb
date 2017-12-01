class CodecsTables < ActiveRecord::Migration
  def self.up
    create_table :visitors do | table |
      table.column :created_at, :datetime
      table.column :os_release, :string
      table.column :application, :string
      table.column :language, :string
      table.column :client_version, :string
      table.column :kernel, :string
      table.column :gstreamer_package, :string
      table.column :xine_package, :string
      table.column :user_agent, :string
      table.column :ip_address, :string
    end

    create_table :missing_codecs do | table |
      table.column :visitor_id, :integer
      table.column :framework, :string
      table.column :framework_version, :string
      table.column :fourcc, :string
    end
  end

  def self.down
    drop_table :visitors
    drop_table :missing_codecs
  end
end
