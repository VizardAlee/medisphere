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

ActiveRecord::Schema[7.2].define(version: 2025_02_26_200639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "emergency_access_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_emergency_access_logs_on_patient_id"
    t.index ["user_id"], name: "index_emergency_access_logs_on_user_id"
  end

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
    t.boolean "emergency_type", default: false
    t.bigint "parent_id"
    t.string "status", default: "pending"
    t.string "appeal_status"
    t.text "appeal_reason"
    t.boolean "approved"
    t.string "state"
    t.string "emergency_organization_type"
    t.index ["parent_id"], name: "index_organizations_on_parent_id"
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
    t.string "blood_type"
    t.text "allergies"
    t.text "chronic_conditions"
    t.text "current_medications"
    t.text "immunization_records"
    t.text "family_medical_history"
    t.string "emergency_contact_name"
    t.string "emergency_contact_relationship"
    t.string "emergency_contact_phone"
    t.string "insurance_provider"
    t.string "insurance_policy_number"
    t.boolean "organ_donor_status", default: false
    t.string "address"
    t.string "photo_url"
    t.datetime "last_visit_date"
    t.datetime "registration_date"
    t.string "username"
    t.string "password_digest"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "national_identity_number"
    t.string "voter_id"
    t.index ["email"], name: "index_patients_on_email", unique: true
    t.index ["hospital_id"], name: "index_patients_on_hospital_id"
    t.index ["national_identity_number"], name: "index_patients_on_national_identity_number", unique: true
    t.index ["organization_id"], name: "index_patients_on_organization_id"
    t.index ["phone"], name: "index_patients_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_patients_on_reset_password_token", unique: true
    t.index ["voter_id"], name: "index_patients_on_voter_id", unique: true
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
    t.string "qualification"
    t.integer "years_of_experience"
    t.string "photo_url"
    t.boolean "verified", default: false
    t.string "state"
    t.string "emergency_organization_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verification_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "respondent_id", null: false
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["respondent_id"], name: "index_verification_logs_on_respondent_id"
    t.index ["user_id"], name: "index_verification_logs_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "emergency_access_logs", "patients"
  add_foreign_key "emergency_access_logs", "users"
  add_foreign_key "health_records", "patients"
  add_foreign_key "health_records", "users"
  add_foreign_key "organizations", "organizations", column: "parent_id"
  add_foreign_key "patients", "hospitals"
  add_foreign_key "patients", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "verification_logs", "users"
  add_foreign_key "verification_logs", "users", column: "respondent_id"
end
