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

ActiveRecord::Schema[8.1].define(version: 2026_11_28_125308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('english'::regconfig, (COALESCE(name, ''::character varying))::text)", stored: true
    t.index ["inventory_id", "name"], name: "index_categories_on_inventory_id_and_name", unique: true
    t.index ["inventory_id"], name: "index_categories_on_inventory_id"
    t.index ["search_vector"], name: "index_categories_on_search_vector", using: :gin
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

  create_table "discussion_post_likes", force: :cascade do |t|
    t.bigint "discussion_post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_post_id", "user_id"], name: "index_discussion_post_likes_on_post_and_user", unique: true
    t.index ["discussion_post_id"], name: "index_discussion_post_likes_on_discussion_post_id"
    t.index ["user_id"], name: "index_discussion_post_likes_on_user_id"
  end

  create_table "discussion_posts", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_discussion_posts_on_inventory_id"
    t.index ["user_id"], name: "index_discussion_posts_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "visibility", default: "private", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_id", null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('english'::regconfig, (((((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)) || ' '::text) || (COALESCE(custom_id, ''::character varying))::text))", stored: true
    t.index ["custom_id"], name: "index_inventories_on_custom_id", unique: true
    t.index ["search_vector"], name: "index_inventories_on_search_vector", using: :gin
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "inventory_accesses", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id", "user_id"], name: "index_inventory_accesses_on_inventory_id_and_user_id", unique: true
    t.index ["inventory_id"], name: "index_inventory_accesses_on_inventory_id"
    t.index ["user_id"], name: "index_inventory_accesses_on_user_id"
  end

  create_table "inventory_tags", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id", "tag_id"], name: "index_inventory_tags_on_inventory_id_and_tag_id", unique: true
    t.index ["inventory_id"], name: "index_inventory_tags_on_inventory_id"
    t.index ["tag_id"], name: "index_inventory_tags_on_tag_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "category_id"
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "custom_field_values", default: {}, null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", stored: true
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["inventory_id"], name: "index_items_on_inventory_id"
    t.index ["search_vector"], name: "index_items_on_search_vector", using: :gin
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.string "theme", default: "light", null: false
  end

  add_foreign_key "categories", "inventories"
  add_foreign_key "custom_fields", "inventories"
  add_foreign_key "discussion_post_likes", "discussion_posts"
  add_foreign_key "discussion_post_likes", "users"
  add_foreign_key "discussion_posts", "inventories"
  add_foreign_key "discussion_posts", "users"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventory_accesses", "inventories"
  add_foreign_key "inventory_accesses", "users"
  add_foreign_key "inventory_tags", "inventories"
  add_foreign_key "inventory_tags", "tags"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "inventories"
end
