# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20121218194957) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  create_table "download_histories", force: true do |t|
    t.string   "base"
    t.string   "query"
    t.string   "file"
    t.string   "ymp"
    t.datetime "created_at"
  end

  create_table "orders", force: true do |t|
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

  create_table "search_histories", force: true do |t|
    t.string   "base"
    t.string   "query"
    t.integer  "count"
    t.integer  "binaries"
    t.integer  "patterns"
    t.datetime "created_at"
  end

end
