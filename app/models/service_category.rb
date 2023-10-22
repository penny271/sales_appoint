class ServiceCategory < ApplicationRecord
  has_many :appointments

  # 商材名: 必須
  validates :name, presence: true

  # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(id name description price initial_cost img_url created_at updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end
end
