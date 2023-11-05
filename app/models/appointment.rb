class Appointment < ApplicationRecord
  # - STIではここで書いたものが smm_appointment.rb と cx_appointment.rbにも共有されるため
  # - 上記のファイルに下記を別々に記述する必要なし
  belongs_to :account
  belongs_to :service_category
  belongs_to :commodity_category

  # - 既定はSTI使用時に自動で typeカラムに SmmAppointmentのように保存されるが、
  # - それだと長すぎるため、下記のように条件に応じて Smm or Cx として保存されるようにした。

  def self.inheritance_column
    "type"
  end

  def self.sti_name
    case self.name
    when "SmmAppointment"
      "Smm"
    when "CxAppointment"
      "Cx"
    else
      super
    end
  end

  def self.find_sti_class(type_name)
    case type_name
    when "Smm"
      SmmAppointment
    when "Cx"
      CxAppointment
    else
      super
    end
  end


  # # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(id account_id service_category_id commodity_category_id duplication company_name company_tel company_url instagram_url content call_date next_call_date sent_material_date is_next_call end_date)
  end
end