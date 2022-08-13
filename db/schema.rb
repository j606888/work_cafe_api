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

ActiveRecord::Schema[7.0].define(version: 2022_08_13_060522) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "cube"
  enable_extension "earthdistance"
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_favorites_on_store_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "hiddens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_hiddens_on_store_id"
    t.index ["user_id"], name: "index_hiddens_on_user_id"
  end

  create_table "map_crawlers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "lat"
    t.float "lng"
    t.integer "radius"
    t.integer "total_found", default: 0
    t.integer "new_store_count", default: 0
    t.integer "repeat_store_count", default: 0
    t.integer "blacklist_store_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_map_crawlers_on_user_id"
  end

  create_table "map_urls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "url", null: false
    t.string "keyword"
    t.string "place_id"
    t.string "decision"
    t.jsonb "source_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_map_urls_on_user_id"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.integer "open_day", null: false
    t.string "open_time", limit: 10, null: false
    t.integer "close_day", null: false
    t.string "close_time", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_opening_hours_on_store_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.boolean "is_valid", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "store_photos", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "random_key", null: false
    t.string "image_url"
    t.string "photo_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_photos_on_store_id"
  end

  create_table "store_sources", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.jsonb "source_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_sources_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "place_id", null: false
    t.string "name", null: false
    t.string "address"
    t.string "phone"
    t.string "url", null: false
    t.string "website"
    t.float "rating"
    t.integer "user_ratings_total"
    t.string "image_url"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "district"
    t.boolean "permanently_closed", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.index ["place_id"], name: "index_stores_on_place_id", unique: true
  end

  create_table "third_party_logins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_third_party_logins_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "favorites", "stores"
  add_foreign_key "favorites", "users"
  add_foreign_key "hiddens", "stores"
  add_foreign_key "hiddens", "users"
  add_foreign_key "map_crawlers", "users"
  add_foreign_key "map_urls", "users"
  add_foreign_key "opening_hours", "stores"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "store_photos", "stores"
  add_foreign_key "store_sources", "stores"
  add_foreign_key "third_party_logins", "users"
end
