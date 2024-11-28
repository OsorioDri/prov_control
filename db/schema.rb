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

ActiveRecord::Schema[7.1].define(version: 2024_11_17_161504) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "address"
    t.string "emailable_type", null: false
    t.bigint "emailable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emailable_type", "emailable_id"], name: "index_emails_on_emailable"
  end

  create_table "enrollments", force: :cascade do |t|
    t.date "contact_date"
    t.boolean "invited"
    t.date "date_invitation_accepted"
    t.text "note"
    t.bigint "municipality_id", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["municipality_id"], name: "index_enrollments_on_municipality_id"
    t.index ["provider_id"], name: "index_enrollments_on_provider_id"
  end

  create_table "municipalities", force: :cascade do |t|
    t.string "name"
    t.string "contact_name"
    t.string "contact_title"
    t.integer "original_coordinator"
    t.integer "number_of_attempts"
    t.date "date_last_attempt"
    t.boolean "contact_effective"
    t.date "official_letter_sent"
    t.boolean "capital_city"
    t.bigint "state_id", null: false
    t.bigint "batch_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_municipalities_on_batch_id"
    t.index ["state_id"], name: "index_municipalities_on_state_id"
    t.index ["user_id"], name: "index_municipalities_on_user_id"
  end

  create_table "phones", force: :cascade do |t|
    t.string "number"
    t.string "callable_type", null: false
    t.bigint "callable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["callable_type", "callable_id"], name: "index_phones_on_callable"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "site_url"
    t.string "contact_name"
    t.date "acceptance_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "profile", default: "Coordinator"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "municipalities"
  add_foreign_key "enrollments", "providers"
  add_foreign_key "municipalities", "batches"
  add_foreign_key "municipalities", "states"
  add_foreign_key "municipalities", "users"
end
