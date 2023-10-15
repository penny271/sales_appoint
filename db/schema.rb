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

ActiveRecord::Schema[7.0].define(version: 2023_10_15_094103) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_kana", default: ""
    t.string "email", default: "", null: false
    t.string "tel", default: ""
    t.string "hashed_password"
    t.boolean "suspended", default: false, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "appointments", id: { comment: "class CreateAppointments < ActiveRecord::Migration[7.0]\n  def change\n    create_table :appointments do |t|\n      t.references :account, foreign_key: true, null: false\n      t.references :service_category, foreign_key: true, null: false\n      t.string :type #! STI(Single Table Inheritance) column\n      t.string :duplication, null: false, default: 'なし'\n      t.string :partial_duplication, null: false, default: 'なし'\n      t.string :company_name, null: false\n      t.string :company_tel\n      t.text :instagram_url #! this column can now be used for records of type 'SMM', but it'll exist for all records.\n      t.text :content\n      t.date :call_date\n      t.date :next_call_date\n      t.date :sent_material_date\n      t.integer :is_next_call\n      t.date :end_date\n\n      t.timestamps\n    end\n\n    add_index :appointments, [:company_name, :service_category_id], unique: true\n  end\nend\n" }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "service_category_id", null: false
    t.string "type", comment: "STI(Single Table Inheritance) column :  Smm or Cx"
    t.string "duplication", default: "なし", null: false
    t.string "partial_duplication", default: "なし", null: false
    t.string "company_name", null: false
    t.string "company_tel"
    t.text "instagram_url"
    t.text "content"
    t.date "call_date"
    t.date "next_call_date"
    t.date "sent_material_date"
    t.integer "is_next_call"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "commodity_category_id", null: false
    t.index ["account_id"], name: "index_appointments_on_account_id"
    t.index ["commodity_category_id"], name: "index_appointments_on_commodity_category_id"
    t.index ["company_name", "service_category_id"], name: "index_appointments_on_company_name_and_service_category_id", unique: true
    t.index ["service_category_id"], name: "index_appointments_on_service_category_id"
  end

  create_table "commodity_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "price"
    t.integer "initial_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "img_url"
  end

  add_foreign_key "appointments", "accounts"
  add_foreign_key "appointments", "commodity_categories"
  add_foreign_key "appointments", "service_categories"
end
