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

ActiveRecord::Schema.define(version: 20140618145757) do

  create_table "brands", force: true do |t|
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dealers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "brand_id"
    t.integer  "dealer_id"
    t.integer  "car_model_id"
    t.string   "state"
    t.string   "number"
    t.datetime "accepted_at"
    t.datetime "completed_at"
    t.text     "finish_comment"
    t.text     "accept_comment"
    t.text     "complete_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["brand_id"], name: "index_orders_on_brand_id", using: :btree
  add_index "orders", ["dealer_id"], name: "index_orders_on_dealer_id", using: :btree

end
