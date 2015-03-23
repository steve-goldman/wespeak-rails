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

ActiveRecord::Schema.define(version: 20150323221947) do

  create_table "active_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "active_seconds"
  end

  add_index "active_members", ["group_id"], name: "index_active_members_on_group_id"
  add_index "active_members", ["user_id"], name: "index_active_members_on_user_id"

  create_table "email_addresses", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "domain"
  end

  add_index "email_addresses", ["email"], name: "index_email_addresses_on_email"
  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id"

  create_table "group_email_domains", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_email_domains", ["group_id"], name: "index_group_email_domains_on_group_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "active",                          default: false
    t.integer  "user_id"
    t.integer  "lifespan_rule"
    t.integer  "support_needed_rule"
    t.integer  "votespan_rule"
    t.integer  "votes_needed_rule"
    t.integer  "yeses_needed_rule"
    t.integer  "inactivity_timeout_rule"
    t.integer  "invitations"
    t.integer  "initial_lifespan_rule"
    t.integer  "initial_support_needed_rule"
    t.integer  "initial_votespan_rule"
    t.integer  "initial_votes_needed_rule"
    t.integer  "initial_yeses_needed_rule"
    t.integer  "initial_inactivity_timeout_rule"
    t.integer  "initial_invitations"
    t.text     "tagline"
  end

  add_index "groups", ["name"], name: "index_groups_on_name"

  create_table "statements", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "statement_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "state"
    t.integer  "lifespan"
  end

  add_index "statements", ["group_id"], name: "index_statements_on_group_id"
  add_index "statements", ["statement_type"], name: "index_statements_on_statement_type"
  add_index "statements", ["user_id"], name: "index_statements_on_user_id"

  create_table "taglines", force: :cascade do |t|
    t.text     "tagline"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "statement_id"
  end

  add_index "taglines", ["statement_id"], name: "index_taglines_on_statement_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "primary_email_address_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "remember_digest"
    t.string   "password_reset_digest"
    t.datetime "password_reset_sent_at"
    t.string   "password_digest"
    t.boolean  "can_create_groups",        default: false
  end

end
