class CommodityCategory < ApplicationRecord
  has_many :appointments

  # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(created_at id name updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end
end
