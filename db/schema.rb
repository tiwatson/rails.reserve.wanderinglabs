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

ActiveRecord::Schema.define(version: 20170707022147) do

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
    t.date "avail_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "import"
    t.index ["facility_id"], name: "index_availabilities_on_facility_id"
    t.index ["site_id"], name: "index_availabilities_on_site_id"
  end

  create_table "availability_matches", force: :cascade do |t|
    t.bigint "availability_request_id"
    t.bigint "site_id"
    t.date "avail_date"
    t.integer "length"
    t.boolean "available", default: false, null: false
    t.datetime "unavailable_at"
    t.datetime "notified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_request_id"], name: "index_availability_matches_on_availability_request_id"
    t.index ["site_id"], name: "index_availability_matches_on_site_id"
  end

  create_table "availability_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "facility_id"
    t.date "date_start"
    t.date "date_end"
    t.integer "stay_length"
    t.jsonb "details"
    t.text "site_ids", default: [], array: true
    t.text "sites_ext_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pullthru"
    t.boolean "water"
    t.boolean "sewer"
    t.integer "min_electric"
    t.integer "min_length"
    t.string "site_type"
    t.text "specific_site_ids"
    t.index ["facility_id"], name: "index_availability_requests_on_facility_id"
    t.index ["user_id"], name: "index_availability_requests_on_user_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "name"
    t.string "type"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "booking_window"
    t.datetime "last_import"
    t.string "last_import_hash"
    t.index ["agency_id"], name: "index_facilities_on_agency_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "facility_id"
    t.string "ext_site_id"
    t.string "site_num"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pullthru", default: false, null: false
    t.boolean "water", default: false, null: false
    t.boolean "sewer", default: false, null: false
    t.integer "electric"
    t.integer "length"
    t.string "site_type"
    t.index ["facility_id"], name: "index_sites_on_facility_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.datetime "last_seen"
    t.string "login_token"
    t.index ["auth_token"], name: "index_users_on_auth_token"
    t.index ["login_token"], name: "index_users_on_login_token"
  end

  add_foreign_key "availabilities", "facilities"
  add_foreign_key "availabilities", "sites"
  add_foreign_key "availability_matches", "availability_requests"
  add_foreign_key "availability_matches", "sites"
  add_foreign_key "availability_requests", "facilities"
  add_foreign_key "availability_requests", "users"
  add_foreign_key "facilities", "agencies"
  add_foreign_key "sites", "facilities"
end
