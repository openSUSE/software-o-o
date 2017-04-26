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

ActiveRecord::Schema.define(version: 20170425185949) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      limit: nil
  end

  create_table "download_histories", force: true do |t|
    t.string   "base",       limit: nil
    t.string   "query",      limit: nil
    t.string   "file",       limit: nil
    t.string   "ymp",        limit: nil
    t.datetime "created_at"
  end

end
