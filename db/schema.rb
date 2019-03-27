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

ActiveRecord::Schema.define(version: 20190325071724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.string "password_digest"
    t.string "confirmation_digest"
    t.datetime "confirmed_at"
    t.string "reset_password_digest"
    t.datetime "reset_password_sent_at"
    t.string "remember_digest"
    t.datetime "remember_created_at"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "name"
    t.string "sex"
    t.integer "year_of_birth"
    t.integer "month_of_birth"
    t.integer "day_of_birth"
    t.string "mobile_phone"
    t.string "telephone"
    t.string "fax"
    t.string "company"
    t.string "company_addr"
    t.string "department"
    t.string "position"
    t.string "website"
  end

  create_table "collection_associations", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "product_id"
    t.index ["account_id"], name: "index_collection_associations_on_account_id"
    t.index ["product_id"], name: "index_collection_associations_on_product_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "sex"
    t.string "birthday"
    t.string "mobile_phone"
    t.string "telephone"
    t.string "fax"
    t.string "company"
    t.string "company_addr"
    t.string "department"
    t.string "position"
    t.string "email"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mail_tasks", force: :cascade do |t|
    t.bigint "my_mail_id"
    t.string "to_email"
    t.string "status"
    t.integer "retry_limit"
    t.string "run_batch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["my_mail_id"], name: "index_mail_tasks_on_my_mail_id"
  end

  create_table "my_mails", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.jsonb "to_emails", default: []
    t.string "status"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_access_logs", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_product_access_logs_on_customer_id"
    t.index ["product_id"], name: "index_product_access_logs_on_product_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "grade"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku_code"
    t.text "description"
    t.bigint "pv"
    t.bigint "author_id"
    t.string "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
