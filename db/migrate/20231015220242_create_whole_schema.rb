class CreateWholeSchema < ActiveRecord::Migration[7.0]
  def change
    create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.string "name", null: false
      t.string "name_kana", default: ""
      t.string "email", default: "", null: false
      t.string "tel", default: ""
      t.string "hashed_password"
      t.boolean "suspended", default: false, null: false
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
      t.datetime "updated_at"
    end

    create_table "appointments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.bigint "account_id", null: false
      t.bigint "service_category_id", null: false
      t.bigint "commodity_category_id", null: false
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
      t.timestamps null: false
    end

    add_index :appointments, ["account_id"], name: "index_appointments_on_account_id"
    add_index :appointments, ["commodity_category_id"], name: "index_appointments_on_commodity_category_id"
    add_index :appointments, ["company_name", "service_category_id"], name: "index_appointments_on_company_name_and_service_category_id", unique: true
    add_index :appointments, ["service_category_id"], name: "index_appointments_on_service_category_id"

    create_table "commodity_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.string "name", null: false
      t.timestamps null: false
    end

    create_table "service_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.string "name"
      t.text "description"
      t.integer "price"
      t.integer "initial_cost"
      t.timestamps null: false
      t.text "img_url"
    end
  end
end
