class DropOrders < ActiveRecord::Migration
  def change
    drop_table "orders", force: true do |t|
      t.string   "title",        null: false
      t.string   "name",         null: false
      t.string   "company"
      t.string   "street1",      null: false
      t.string   "street2"
      t.string   "zip",          null: false
      t.string   "city",         null: false
      t.string   "county"
      t.string   "country",      null: false
      t.string   "phone",        null: false
      t.string   "email",        null: false
      t.integer  "amount",       null: false
      t.text     "reason",       null: false
      t.string   "deadline",     null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "processed_at"
      t.string   "processed_by"
      t.string   "material"
    end
  end
end
