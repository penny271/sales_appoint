class AddColumnsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.text :description
      t.integer :gender
      t.string :employment_type
      t.integer :is_suspended
      t.integer :is_admin
    end
  end
end