class RemoveSuspendedFromAccounts < ActiveRecord::Migration[6.0] # or your Rails version
  def change
    remove_column :accounts, :suspended, :boolean
  end
end