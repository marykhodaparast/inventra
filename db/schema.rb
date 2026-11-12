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

ActiveRecord::Schema[8.1].define(version: 2026_11_12_160705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id", "name"], name: "index_categories_on_inventory_id_and_name", unique: true
    t.index ["inventory_id"], name: "index_categories_on_inventory_id"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.string "name", null: false
    t.string "field_type", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id", "name"], name: "index_custom_fields_on_inventory_id_and_name", unique: true
    t.index ["inventory_id"], name: "index_custom_fields_on_inventory_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "visibility", default: "private", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "category_id"
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "custom_field_values", default: {}, null: false
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["inventory_id"], name: "index_items_on_inventory_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bio"
    t.string "avatar_url"
    t.string "role", default: "user", null: false
  end

  add_foreign_key "categories", "inventories"
  add_foreign_key "custom_fields", "inventories"
  add_foreign_key "inventories", "users"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "inventories"
end
