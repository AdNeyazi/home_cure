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

ActiveRecord::Schema[8.1].define(version: 2026_04_25_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bill_items", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.datetime "created_at", null: false
    t.decimal "discount_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.string "discount_type", default: "none", null: false
    t.decimal "discount_value", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "line_total", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 1, null: false
    t.bigint "test_id", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_items_on_bill_id"
    t.index ["test_id"], name: "index_bill_items_on_test_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount_due", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "amount_paid", precision: 12, scale: 2, default: "0.0", null: false
    t.date "bill_date", null: false
    t.string "bill_number"
    t.datetime "created_at", null: false
    t.bigint "patient_id", null: false
    t.string "status", default: "pending", null: false
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_date"], name: "index_bills_on_bill_date"
    t.index ["bill_number"], name: "index_bills_on_bill_number", unique: true
    t.index ["patient_id"], name: "index_bills_on_patient_id"
    t.index ["status"], name: "index_bills_on_status"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "author_name", default: "Home Cure Lab Team", null: false
    t.string "category", null: false
    t.text "content", null: false
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.text "excerpt", null: false
    t.text "faq_items"
    t.boolean "featured", default: false, null: false
    t.text "medical_disclaimer"
    t.text "preparation_tips"
    t.boolean "published", default: true, null: false
    t.datetime "published_at", null: false
    t.datetime "reviewed_at"
    t.string "reviewer_name"
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_blog_posts_on_category"
    t.index ["published"], name: "index_blog_posts_on_published"
    t.index ["published_at"], name: "index_blog_posts_on_published_at"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "contact_inquiries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.text "message", null: false
    t.string "phone_number"
    t.string "status", default: "new", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_contact_inquiries_on_created_at"
    t.index ["status"], name: "index_contact_inquiries_on_status"
  end

  create_table "doctors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name", null: false
    t.string "phone_number"
    t.string "specialization", null: false
    t.datetime "updated_at", null: false
    t.index ["full_name"], name: "index_doctors_on_full_name"
    t.index ["specialization"], name: "index_doctors_on_specialization"
  end

  create_table "patients", force: :cascade do |t|
    t.text "address"
    t.integer "age"
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.bigint "doctor_id"
    t.string "email"
    t.string "full_name", null: false
    t.string "gender"
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_patients_on_doctor_id"
    t.index ["full_name"], name: "index_patients_on_full_name"
    t.index ["phone_number"], name: "index_patients_on_phone_number"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "doctor_id"
    t.string "file_path"
    t.text "notes"
    t.bigint "patient_id", null: false
    t.date "reported_on"
    t.bigint "test_id"
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_reports_on_doctor_id"
    t.index ["patient_id"], name: "index_reports_on_patient_id"
    t.index ["test_id"], name: "index_reports_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tests_on_code", unique: true
    t.index ["name"], name: "index_tests_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "admin", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "bill_items", "bills"
  add_foreign_key "bill_items", "tests"
  add_foreign_key "bills", "patients"
  add_foreign_key "patients", "doctors"
  add_foreign_key "reports", "doctors"
  add_foreign_key "reports", "patients"
  add_foreign_key "reports", "tests"
end
