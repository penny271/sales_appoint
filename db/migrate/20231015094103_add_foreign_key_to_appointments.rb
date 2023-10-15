class AddForeignKeyToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :appointments, :commodity_categories, column: :commodity_category_id
  end
end
