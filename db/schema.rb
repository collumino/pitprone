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

ActiveRecord::Schema.define(version: 20150701085322) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "firstname",  limit: 255
    t.string   "street",     limit: 255
    t.string   "city",       limit: 255
    t.string   "phone",      limit: 255
    t.string   "mobile",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.integer  "property_id",        limit: 4
    t.text     "name",               limit: 65535
    t.text     "additional_remarks", limit: 65535
    t.decimal  "price",                            precision: 10, scale: 2, default: 0.0
    t.boolean  "is_default",         limit: 1
    t.boolean  "vegan",              limit: 1
    t.string   "category",           limit: 255
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  add_index "ingredients", ["property_id"], name: "index_ingredients_on_property_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.decimal  "total",                  precision: 10, scale: 2, default: 0.0
    t.string   "state",      limit: 255
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "pizza_items", force: :cascade do |t|
    t.integer  "pizza_id",      limit: 4
    t.integer  "ingredient_id", limit: 4
    t.integer  "quantity",      limit: 4
    t.decimal  "total",                   precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  add_index "pizza_items", ["ingredient_id"], name: "index_pizza_items_on_ingredient_id", using: :btree
  add_index "pizza_items", ["pizza_id"], name: "index_pizza_items_on_pizza_id", using: :btree

  create_table "pizzas", force: :cascade do |t|
    t.integer  "order_id",    limit: 4
    t.decimal  "total",                  precision: 10, scale: 2, default: 0.0
    t.float    "size_factor", limit: 24,                                        null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "pizzas", ["order_id"], name: "index_pizzas_on_order_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.boolean  "sugar",       limit: 1
    t.boolean  "antioxidant", limit: 1
    t.boolean  "dye",         limit: 1
    t.boolean  "conserve",    limit: 1
    t.boolean  "phophate",    limit: 1
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255, default: "", null: false
    t.string   "encrypted_password",   limit: 255, default: "", null: false
    t.integer  "sign_in_count",        limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "authentication_token", limit: 255
    t.string   "name",                 limit: 255
    t.integer  "role",                 limit: 4
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "ingredients", "properties"
  add_foreign_key "orders", "users"
  add_foreign_key "pizza_items", "ingredients"
  add_foreign_key "pizza_items", "pizzas"
  add_foreign_key "pizzas", "orders"
end
