class LoginForm
  # ¥ ch1.8.2 ポイントは2つあります。1つは ActiveRecord::Base クラスを継承しないこと、もう1つは ActiveModel::Model を include することです。これで、 form_with の model オプションに指定できるようになります。 attr_accessor で定義している属性は、そのままフォームのフィールド名となります
  include ActiveModel::Model

  attr_accessor :email, :password
end