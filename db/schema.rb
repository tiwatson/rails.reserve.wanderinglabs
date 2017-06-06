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

ActiveRecord::Schema.define(version: 20170603050304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "facility_id"
    t.bigint "site_id"
    t.string "scrape"
    t.date "avail_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_availabilities_on_facility_id"
    t.index ["site_id"], name: "index_availabilities_on_site_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "name"
    t.string "type"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_facilities_on_agency_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "facility_id"
    t.string "ext_site_id"
    t.string "site_num"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_sites_on_facility_id"
  end

  add_foreign_key "availabilities", "facilities"
  add_foreign_key "availabilities", "sites"
  add_foreign_key "facilities", "agencies"
  add_foreign_key "sites", "facilities"
end
