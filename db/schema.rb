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

ActiveRecord::Schema.define(version: 20150202192317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: true do |t|
    t.string   "name"
    t.float    "long"
    t.float    "lat"
    t.string   "desc"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "place_id"
    t.string   "city"
  end

  create_table "users", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "windows", force: true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "open_day"
    t.integer  "close_day"
    t.integer  "open_time"
    t.integer  "close_time"
  end

end
