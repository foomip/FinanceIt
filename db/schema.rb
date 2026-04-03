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

ActiveRecord::Schema[8.1].define(version: 2026_04_03_110000) do
  create_table "broker_applicants", force: :cascade do |t|
    t.string "address_line_1", null: false
    t.integer "broker_application_id", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth", null: false
    t.string "employment_status", null: false
    t.string "first_name", null: false
    t.string "postcode", null: false
    t.string "surname", null: false
    t.integer "time_at_current_employer_years", null: false
    t.datetime "updated_at", null: false
    t.index ["broker_application_id"], name: "index_broker_applicants_on_broker_application_id", unique: true
  end

  create_table "broker_applications", force: :cascade do |t|
    t.string "application_reference", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_reference"], name: "index_broker_applications_on_application_reference", unique: true
  end

  create_table "broker_finances", force: :cascade do |t|
    t.decimal "amount_to_finance", precision: 10, scale: 2, null: false
    t.decimal "apr", precision: 5, scale: 2, null: false
    t.integer "broker_application_id", null: false
    t.decimal "cash_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.decimal "deposit", precision: 10, scale: 2, null: false
    t.decimal "glass_guide_retail_estimate", precision: 10, scale: 2, null: false
    t.decimal "monthly_payment", precision: 10, scale: 2, null: false
    t.decimal "total_amount_payable", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["broker_application_id"], name: "index_broker_finances_on_broker_application_id", unique: true
  end

  create_table "broker_hp_agreements", force: :cascade do |t|
    t.string "address_line_1", null: false
    t.decimal "advance_amount", precision: 10, scale: 2, null: false
    t.decimal "apr", precision: 5, scale: 2, null: false
    t.integer "broker_application_id", null: false
    t.decimal "cash_price", precision: 10, scale: 2, null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth", null: false
    t.decimal "deposit", precision: 10, scale: 2, null: false
    t.date "first_payment_date", null: false
    t.string "full_name", null: false
    t.string "make_model", null: false
    t.decimal "monthly_payment", precision: 10, scale: 2, null: false
    t.string "postcode", null: false
    t.string "registration", null: false
    t.integer "term_months", null: false
    t.decimal "total_amount_payable", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_year", null: false
    t.index ["broker_application_id"], name: "index_broker_hp_agreements_on_broker_application_id", unique: true
    t.index ["registration"], name: "index_broker_hp_agreements_on_registration"
  end

  create_table "broker_vehicles", force: :cascade do |t|
    t.integer "broker_application_id", null: false
    t.datetime "created_at", null: false
    t.string "make_model", null: false
    t.integer "mileage", null: false
    t.string "registration", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["broker_application_id"], name: "index_broker_vehicles_on_broker_application_id", unique: true
    t.index ["registration"], name: "index_broker_vehicles_on_registration"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "broker_applicants", "broker_applications"
  add_foreign_key "broker_finances", "broker_applications"
  add_foreign_key "broker_hp_agreements", "broker_applications"
  add_foreign_key "broker_vehicles", "broker_applications"
end
