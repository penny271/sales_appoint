class AddDefaultsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :accounts, :name_kana, ''
    change_column_default :accounts, :email, ''
    change_column_default :accounts, :tel, ''
    change_column_default :accounts, :hashed_password, ''
  end
end
