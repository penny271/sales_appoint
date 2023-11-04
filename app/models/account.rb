class Account < ApplicationRecord
  include StringNormalizer

  HUMAN_NAME_REGEXP = /\A[\p{han}\p{hiragana}\p{katakana}\u{30fc}A-Za-z]+\z/
  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/

  has_many :appointments

  attr_accessor :password, :password_confirmation
  # ¥ if @commodity_category.saveのタイミングで before_validationが起こる
  #  *  @commodity_category = CommodityCategory.new(commodity_categories_params)
  # * if @commodity_category.save
  before_validation do
    # * 引数の name は、現在のCommodityCategoryのインスタンスのname属性を指し、通常はデータベースのcommodity_categoriesテーブルのnameというカラムに対応する。
    # Store the original name before normalizing
    # self.original_name = name
    # Normalize the name
    self.name = normalize_as_name(name)
    self.name_kana = normalize_as_furigana(name_kana)
    self.email = normalize_as_email(email)
    # self.password = password
    # self.password_confirmation = password_confirmation

    # Normalize the name
    self.name = normalize_as_name(name)

    # ! # Normalize the 価格 rails7になったからか全角数字を半角に勝手に変更してくれている
    # self.price = normalize_zenkaku_number_to_number(price)
    # # Normalize the 初期費用
    # self.initial_cost = normalize_zenkaku_number_to_number(initial_cost)
  end

  # This callback hashes the password before saving (both create and update)
  before_save :hash_password_if_present

  # 余分な空白があった場合、取り除き、取り除いた旨のエラーメッセージを表示させる
  # validate_without_extra_spaces(:original_name, :name)

  # Validations
  # validates :password, presence: true, confirmation: true
  # validates :password_confirmation, presence: true

  # 必須
  validates :name, presence: true
  # ¥ ^ をつけると属性名を表示させないようにできる
  validates :name_kana, format: { with: KATAKANA_REGEXP, message: "はカタカナで入力してください", allow_blank: true }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :tel, format: { with: /\A\d+\z/, message: "は数字以外を含めないでください", allow_blank: true }

  # 文字制限 type text でない限り VARCHAR(255)
  validates_length_of :name, maximum: 255, message: "が長すぎます。255文字以内にしてください"

  # validates :password, presence: true, confirmation: true
  #- Validates password presence and confirmation only if it's present, mostly for updates.
  validates :password, presence: true, confirmation: true, if: :password_present?

  # # 正の整数限定 sqlの型が integer の場合の最大値は 2,147,483,647
  # # ! This validation declaration is evaluated in the class contextのため、format_with_delimiterは
  # # ! module ClassMethodsの中に記述する必要あり　 - クラスレベルで呼び出す必要があるため
  # validates :price, :initial_cost, numericality: {
  #   only_integer: true,
  #   greater_than_or_equal_to: 0,
  #   less_than_or_equal_to: INTEGER_MAX_VALUE, # Maximum value for a 4-byte signed integer
  #   message: "には#{format_with_delimiter(INTEGER_MAX_VALUE)}を上限とした正の整数を入力してください"
  # }

  # # - ransackを使用するため検索に使用する属性を定義する必要あり
  def self.ransackable_attributes(auth_object = nil)
    %w(id name name_kana gender email tel hashed_password employment_type description is_suspended is_admin)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(appointments)
  end

  private

  # This method will be true if password is present, triggering the validation
  def password_present?
    !password.blank?
  end

  # Hashes the password using bcrypt
  def hash_password(password)
    puts("BCrypt::Password.create(password): #{BCrypt::Password.create(password)}")
    BCrypt::Password.create(password)
  end

  # Hashes the password if it's present, ensuring it's only done when needed
  def hash_password_if_present
    puts("hash_password(password) ::: #{hash_password(password)}")
    self.hashed_password = hash_password(password) if password_present?
  end
end
