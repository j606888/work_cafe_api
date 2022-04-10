# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_10_032047) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "opening_hours", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.integer "open_day", null: false
    t.string "open_time", limit: 10, null: false
    t.integer "close_day", null: false
    t.string "close_time", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_opening_hours_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "external_id", null: false
    t.string "address"
    t.string "phone"
    t.boolean "location_lat"
    t.boolean "location_lng"
    t.boolean "rating"
    t.string "url", null: false
    t.string "website"
    t.string "user_ratings_total"
    t.jsonb "source_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "opening_hours", "places"
end
