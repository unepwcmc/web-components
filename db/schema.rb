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

ActiveRecord::Schema.define(version: 2022_10_08_181245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "iso3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attr3"
    t.integer "attr4"
    t.boolean "archived"
  end

  create_table "countries_meas", id: false, force: :cascade do |t|
    t.bigint "mea_id", null: false
    t.bigint "country_id", null: false
    t.index ["country_id", "mea_id"], name: "index_countries_meas_on_country_id_and_mea_id"
    t.index ["mea_id", "country_id"], name: "index_countries_meas_on_mea_id_and_country_id"
  end

  create_table "meas", force: :cascade do |t|
    t.string "name"
    t.date "signed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_projects_on_country_id"
  end

  add_foreign_key "projects", "countries"
end
