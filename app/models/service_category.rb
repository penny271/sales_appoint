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
    # ! # Normalize the 価格 rails7になったからか全角数字を半角に勝手に変更してくれている
    # self.price = normalize_zenkaku_number_to_number(price)
    # # Normalize the 初期費用
    # self.initial_cost = normalize_zenkaku_number_to_number(initial_cost)
  end

  # 余分な空白があった場合、取り除き、取り除いた旨のエラーメッセージを表示させる
  validate_without_extra_spaces(:original_name, :name)

  # 商材名: 必須
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # 文字制限 type text でない限り VARCHAR(255)
  validates_length_of :name, maximum: 255, message: "が長すぎます。255文字以内にしてください"

  # 正の整数限定 sqlの型が integer の場合の最大値は 2,147,483,647
  # ! This validation declaration is evaluated in the class contextのため、format_with_delimiterは
  # ! module ClassMethodsの中に記述する必要あり　 - クラスレベルで呼び出す必要があるため
  validates :price, :initial_cost, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: INTEGER_MAX_VALUE, # Maximum value for a 4-byte signed integer
    message: "には#{format_with_delimiter(INTEGER_MAX_VALUE)}を上限とした正の整数を入力してください"
  }

  # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(id name description price initial_cost img_url created_at updated_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end
end