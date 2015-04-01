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

ActiveRecord::Schema.define(version: 20150401004748) do

  create_table "active_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
    t.datetime "warn_at"
    t.boolean  "warned"
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

  create_table "followers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "followers", ["group_id"], name: "index_followers_on_group_id"
  add_index "followers", ["user_id"], name: "index_followers_on_user_id"

  create_table "group_email_domain_changes", force: :cascade do |t|
    t.integer  "statement_id"
    t.string   "domain"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "change_type"
  end

  add_index "group_email_domain_changes", ["statement_id"], name: "index_group_email_domain_changes_on_statement_id"

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
    t.datetime "invitations_required_since"
  end

  add_index "groups", ["name"], name: "index_groups_on_name"

  create_table "invitations", force: :cascade do |t|
    t.integer  "statement_id"
    t.integer  "invitations"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "invitations", ["statement_id"], name: "index_invitations_on_statement_id"

  create_table "membership_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "membership_histories", ["group_id"], name: "index_membership_histories_on_group_id"
  add_index "membership_histories", ["user_id"], name: "index_membership_histories_on_user_id"

  create_table "pending_invitations", force: :cascade do |t|
    t.string   "email"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pending_invitations", ["email", "group_id"], name: "index_pending_invitations_on_email_and_group_id", unique: true
  add_index "pending_invitations", ["group_id"], name: "index_pending_invitations_on_group_id"

  create_table "received_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "received_invitations", ["group_id"], name: "index_received_invitations_on_group_id"
  add_index "received_invitations", ["user_id", "group_id"], name: "index_received_invitations_on_user_id_and_group_id", unique: true
  add_index "received_invitations", ["user_id"], name: "index_received_invitations_on_user_id"

  create_table "rules", force: :cascade do |t|
    t.integer  "statement_id"
    t.integer  "rule_type"
    t.integer  "rule_value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "rules", ["statement_id"], name: "index_rules_on_statement_id"

  create_table "sent_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sent_invitations", ["email"], name: "index_sent_invitations_on_email"
  add_index "sent_invitations", ["user_id", "group_id", "created_at"], name: "index_sent_invitations_on_user_id_and_group_id_and_created_at"
  add_index "sent_invitations", ["user_id"], name: "index_sent_invitations_on_user_id"

  create_table "statements", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "statement_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "state"
    t.integer  "support_needed"
    t.integer  "eligible_supporters"
    t.datetime "expires_at"
    t.datetime "expired_at"
    t.datetime "vote_began_at"
    t.datetime "vote_ends_at"
    t.datetime "vote_ended_at"
    t.integer  "votes_needed"
    t.integer  "eligible_voters"
    t.integer  "yeses_needed"
  end

  add_index "statements", ["group_id", "created_at"], name: "index_statements_on_group_id_and_created_at"
  add_index "statements", ["group_id"], name: "index_statements_on_group_id"
  add_index "statements", ["statement_type"], name: "index_statements_on_statement_type"
  add_index "statements", ["user_id"], name: "index_statements_on_user_id"

  create_table "supports", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "statement_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "supports", ["statement_id", "user_id"], name: "index_supports_on_statement_id_and_user_id", unique: true
  add_index "supports", ["statement_id"], name: "index_supports_on_statement_id"
  add_index "supports", ["user_id"], name: "index_supports_on_user_id"

  create_table "taglines", force: :cascade do |t|
    t.text     "tagline"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "statement_id"
  end

  add_index "taglines", ["statement_id"], name: "index_taglines_on_statement_id"

  create_table "updates", force: :cascade do |t|
    t.text     "update_text"
    t.integer  "statement_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "updates", ["statement_id"], name: "index_updates_on_statement_id"

  create_table "user_notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "vote_begins_active"
    t.boolean  "vote_ends_active"
    t.boolean  "vote_begins_following"
    t.boolean  "vote_ends_following"
    t.boolean  "support_receipt"
    t.boolean  "vote_receipt"
    t.boolean  "my_statement_dies"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.boolean  "about_to_timeout"
    t.boolean  "timed_out"
    t.boolean  "when_invited"
  end

  add_index "user_notifications", ["user_id"], name: "index_user_notifications_on_user_id"

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

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "statement_id"
    t.integer  "vote"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["statement_id", "user_id"], name: "index_votes_on_statement_id_and_user_id", unique: true
  add_index "votes", ["statement_id"], name: "index_votes_on_statement_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
