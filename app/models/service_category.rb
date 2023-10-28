class ServiceCategory < ApplicationRecord
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

  # 余分な空白があった場合、取り除き、取り除いた旨のエラーメッセージを表示させる
  validate_without_extra_spaces(:original_name, :name)

  # 商材名: 必須
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(id name description price initial_cost img_url created_at updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end
end
