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

ActiveRecord::Schema.define(version: 20171120102541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_ies", force: :cascade do |t|
    t.decimal "percent"
    t.integer "latitude"
    t.integer "longitude"
    t.bigint "gene_id"
    t.bigint "data_x_id"
    t.bigint "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_x_id"], name: "index_data_ies_on_data_x_id"
    t.index ["gene_id"], name: "index_data_ies_on_gene_id"
    t.index ["patient_id"], name: "index_data_ies_on_patient_id"
  end

  create_table "data_xes", force: :cascade do |t|
    t.decimal "percent"
    t.integer "latitude"
    t.integer "longitude"
    t.bigint "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_data_xes_on_patient_id"
  end

  create_table "genes", force: :cascade do |t|
    t.string "name"
    t.integer "longitude"
    t.integer "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "data_ies", "data_xes"
  add_foreign_key "data_ies", "genes"
  add_foreign_key "data_ies", "patients"
  add_foreign_key "data_xes", "patients"
end
