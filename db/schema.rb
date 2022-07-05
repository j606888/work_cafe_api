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

ActiveRecord::Schema[7.0].define(version: 2022_07_03_113415) do
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
    t.string "name", null: false
    t.string "aasm_state"
    t.string "place_id", null: false
    t.float "lat", null: false
    t.float "lng", null: false
    t.jsonb "source_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "map_urls", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "url", null: false
    t.string "keyword", null: false
    t.string "place_id"
    t.string "aasm_state"
    t.jsonb "source_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_map_urls_on_place_id", unique: true
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

  create_table "store_sources", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", null: false
    t.string "place_id", null: false
    t.string "aasm_state", null: false
    t.string "create_type", null: false
    t.jsonb "source_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_store_sources_on_place_id", unique: true
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "phone"
    t.string "url", null: false
    t.string "website"
    t.float "rating"
    t.integer "user_ratings_total"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sourceable_type"
    t.bigint "sourceable_id"
    t.string "city"
    t.string "district"
    t.string "image_url"
    t.index ["sourceable_type", "sourceable_id"], name: "index_stores_on_sourceable"
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

  create_table "wish_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_wish_lists_on_store_id"
    t.index ["user_id"], name: "index_wish_lists_on_user_id"
  end

  add_foreign_key "favorites", "stores"
  add_foreign_key "favorites", "users"
  add_foreign_key "hiddens", "stores"
  add_foreign_key "hiddens", "users"
  add_foreign_key "map_urls", "users"
  add_foreign_key "opening_hours", "stores"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "wish_lists", "stores"
  add_foreign_key "wish_lists", "users"
end
