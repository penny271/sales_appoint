class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :account, foreign_key: true, null: false
      t.references :service_category, foreign_key: true, null: false
      t.string :type #! STI(Single Table Inheritance) column
      t.string :duplication, null: false, default: 'なし'
      t.string :partial_duplication, null: false, default: 'なし'
      t.string :company_name, null: false
      t.string :company_tel
      t.text :instagram_url #! this column can now be used for records of type 'SMM', but it'll exist for all records.
      t.text :content
      t.date :call_date
      t.date :next_call_date
      t.date :sent_material_date
      t.integer :is_next_call
      t.date :end_date

      t.timestamps
    end

    add_index :appointments, [:company_name, :service_category_id], unique: true
  end
end
