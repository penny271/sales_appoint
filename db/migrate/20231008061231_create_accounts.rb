class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false # 名前
      t.string :name_kana # 名前(カナ)
      t.string :email
      t.string :tel
      t.string :hashed_password
      t.boolean :suspended, null: false, default: false # 無効フラグ

      t.timestamps
    end
  end
end
