# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "missing_codecs", :force => true do |t|
    t.integer "visitor_id"
    t.string  "framework"
    t.string  "framework_version"
    t.string  "fourcc"
  end

  add_index "missing_codecs", ["visitor_id"], :name => "visitor_id_index"
  add_index "missing_codecs", ["fourcc"], :name => "fourcc_index"

  create_table "orders", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "name",         :null => false
    t.string   "company"
    t.string   "street1",      :null => false
    t.string   "street2"
    t.string   "zip",          :null => false
    t.string   "city",         :null => false
    t.string   "county"
    t.string   "country",      :null => false
    t.string   "phone",        :null => false
    t.string   "email",        :null => false
    t.integer  "amount",       :null => false
    t.text     "reason",       :null => false
    t.string   "deadline",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
    t.string   "processed_by"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "visitors", :force => true do |t|
    t.datetime "created_at"
    t.string   "os_release"
    t.string   "application"
    t.string   "language"
    t.string   "client_version"
    t.string   "kernel"
    t.string   "gstreamer_package"
    t.string   "xine_package"
    t.string   "user_agent"
    t.string   "ip_address"
  end

  add_index "visitors", ["created_at"], :name => "created_at_index"
  add_index "visitors", ["ip_address"], :name => "ip_address_index"

end
