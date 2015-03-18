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

ActiveRecord::Schema.define(version: 20150318210132) do

  create_table "email_addresses", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
  end

  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "statement_type"
    t.integer  "content_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "statements", ["group_id"], name: "index_statements_on_group_id"
  add_index "statements", ["statement_type"], name: "index_statements_on_statement_type"
  add_index "statements", ["user_id"], name: "index_statements_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "primary_email_address_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "remember_digest"
    t.string   "password_reset_digest"
    t.datetime "password_reset_sent_at"
    t.string   "password_digest"
  end

end
