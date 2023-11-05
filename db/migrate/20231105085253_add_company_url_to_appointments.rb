class AddCompanyUrlToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :company_url, :string
  end
end
