class ChangeConstraintsInAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :accounts, :name_kana, ''
    change_column_null :accounts, :email, false
    change_column_default :accounts, :tel, ''
    change_column_default :accounts, :hashed_password, nil
  end
end