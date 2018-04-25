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

ActiveRecord::Schema.define(version: 20170628221128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.boolean  "comment"
    t.string   "description"
    t.string   "date_time"
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "user_name"
    t.string   "user_initials"
    t.integer  "picture_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string   "title"
    t.boolean  "starred"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "cards", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "labels"
    t.text     "due_date"
    t.boolean  "due_date_highlighted"
    t.boolean  "archived"
    t.integer  "position"
    t.integer  "user_id"
    t.integer  "list_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "slug"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "body"
    t.string   "user_name"
    t.string   "user_initials"
    t.string   "date_time"
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string   "title"
    t.boolean  "archived"
    t.integer  "position"
    t.integer  "user_id"
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "reference_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "image"
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "token"
    t.boolean  "admin"
    t.string   "customer_token"
    t.boolean  "active",          default: true
  end

end
