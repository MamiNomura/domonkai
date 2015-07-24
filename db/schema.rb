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

ActiveRecord::Schema.define(version: 20150724105700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "dougu_categories", force: true do |t|
    t.string   "name",          limit: 50, null: false
    t.string   "japanese_name", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dougu_sub_types", force: true do |t|
    t.integer  "dougu_type_id",            null: false
    t.string   "name",          limit: 50, null: false
    t.string   "japanese_name", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dougu_sub_types", ["dougu_type_id"], name: "index_dougu_sub_types_on_dougu_type_id", using: :btree

  create_table "dougu_types", force: true do |t|
    t.integer  "dougu_category_id",              null: false
    t.string   "name",              limit: 50,   null: false
    t.string   "japanese_name",     limit: 50,   null: false
    t.string   "description",       limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dougu_types", ["dougu_category_id"], name: "index_dougu_types_on_dougu_category_id", using: :btree

  create_table "dougus", force: true do |t|
    t.integer  "dougu_category_id",                     null: false
    t.integer  "dougu_type_id",                         null: false
    t.integer  "dougu_sub_type_id"
    t.string   "name",                     limit: 100,  null: false
    t.string   "japanese_name",            limit: 100,  null: false
    t.string   "description",              limit: 2000
    t.string   "location",                 limit: 100
    t.datetime "last_checked"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_one_file_name"
    t.string   "image_one_content_type"
    t.integer  "image_one_file_size"
    t.datetime "image_one_updated_at"
    t.string   "image_two_file_name"
    t.string   "image_two_content_type"
    t.integer  "image_two_file_size"
    t.datetime "image_two_updated_at"
    t.string   "image_three_file_name"
    t.string   "image_three_content_type"
    t.integer  "image_three_file_size"
    t.datetime "image_three_updated_at"
    t.string   "image_link_one",           limit: 1000
    t.string   "image_link_two",           limit: 1000
    t.string   "image_link_three",         limit: 1000
  end

  add_index "dougus", ["dougu_category_id"], name: "index_dougus_on_dougu_category_id", using: :btree
  add_index "dougus", ["dougu_sub_type_id"], name: "index_dougus_on_dougu_sub_type_id", using: :btree
  add_index "dougus", ["dougu_type_id"], name: "index_dougus_on_dougu_type_id", using: :btree

  create_table "members", force: true do |t|
    t.string   "domonkai_id",         limit: 20,                     null: false
    t.string   "first_name",          limit: 50,                     null: false
    t.string   "last_name",           limit: 50,                     null: false
    t.string   "japanese_first_name", limit: 50
    t.string   "japanese_last_name",  limit: 50
    t.string   "tea_name"
    t.string   "japanese_tea_name"
    t.string   "email"
    t.string   "sex",                 limit: 10,  default: "Female"
    t.string   "address",             limit: 100
    t.string   "city",                limit: 50
    t.string   "state",               limit: 2
    t.string   "zip",                 limit: 15
    t.string   "country",             limit: 20
    t.string   "phone",               limit: 15
    t.string   "fax",                 limit: 15
    t.integer  "sensei_member_id"
    t.datetime "join_date",                                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shikaku_kubun_id"
    t.string   "language"
    t.boolean  "record_updated",                  default: false
    t.boolean  "yakuin",                          default: false
  end

  add_index "members", ["japanese_last_name", "japanese_first_name"], name: "index_members_on_japanese_last_name_and_japanese_first_name", using: :btree
  add_index "members", ["last_name", "first_name"], name: "index_members_on_last_name_and_first_name", using: :btree
  add_index "members", ["sensei_member_id"], name: "index_members_on_sensei_member_id", using: :btree

  create_table "shikaku_kubuns", force: true do |t|
    t.string   "name"
    t.string   "japanese_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
