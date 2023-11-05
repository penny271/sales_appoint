class CommodityCategory < ApplicationRecord
  include StringNormalizer

  has_many :appointments

  attr_accessor :original_name

  # ¥ if @commodity_category.saveのタイミングで before_validationが起こる
  #  *  @commodity_category = CommodityCategory.new(commodity_categories_params)
    # * if @commodity_category.save
  before_validation do
    # * 引数の name は、現在のCommodityCategoryのインスタンスのname属性を指し、通常はデータベースのcommodity_categoriesテーブルのnameというカラムに対応する。
    # Store the original name before normalizing
    self.original_name = name
    # Normalize the name
    self.name = normalize_as_name(name)
  end

  validate :name_without_extra_spaces

  # 商材名: 必須
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Add validation for the name length
  validates_length_of :name, maximum: 255, message: "が長すぎます。255文字以内にしてください"

  # ! errors.add()をつけたい場合のみ必要 - なくても uniqueness 制約にかかるため実質不要
  # Check for extra spaces in the original input
  def name_without_extra_spaces
    if original_name != name
      errors.add(:name, "から余分な空白を取り除きました")
    end
  end

  # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(created_at id name updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end
end