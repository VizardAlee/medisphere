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

ActiveRecord::Schema[7.2].define(version: 2025_02_01_140615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "health_records", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.text "diagnosis"
    t.text "prescription"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["patient_id"], name: "index_health_records_on_patient_id"
    t.index ["user_id"], name: "index_health_records_on_user_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization_type", default: "hospital"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.bigint "hospital_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone", null: false
    t.string "email"
    t.bigint "organization_id", null: false
    t.index ["email"], name: "index_patients_on_email", unique: true
    t.index ["hospital_id"], name: "index_patients_on_hospital_id"
    t.index ["organization_id"], name: "index_patients_on_organization_id"
    t.index ["phone"], name: "index_patients_on_phone", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.bigint "organization_id", null: false
    t.string "name", default: "", null: false
    t.integer "staff_role"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "health_records", "patients"
  add_foreign_key "health_records", "users"
  add_foreign_key "patients", "hospitals"
  add_foreign_key "patients", "organizations"
  add_foreign_key "users", "organizations"
end
