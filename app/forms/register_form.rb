class RegisterForm
  # ¥ ch1.8.2 ポイントは2つあります。1つは ActiveRecord::Base クラスを継承しないこと、もう1つは ActiveModel::Model を include することです。これで、 form_with の model オプションに指定できるようになります。 attr_accessor で定義している属性は、そのままフォームのフィールド名となります
  include ActiveModel::Model
  #! ActiveModel::Modelは自動的に validationをしないため、手動で valid? メソッドを記述しvalidationを行わせる必要がある!!

  # * password が DBにはないカスタム属性 hashed_password化するために必要
  # * 同じパスワードが入力されているかを確認するため confirm_pasword 追加
  attr_accessor :name, :name_kana, :email, :tel, :password, :hashed_password, :description, :gender, :employment_type, :is_suspended, :is_admin, :password_confirmation

  # ! フォームオブジェクトで validationを効かせるためには 手動で valid? メソッドを記述する必要あり!!
  # ¥ RegisterFormオブジェクトのバリデーションが失敗した場合（例えば、パスワードとpassword_confirmationが一致しない場合）、フォームオブジェクト自体が無効なので、Accountモデルを保存しようとする必要すらありません。ですからこの場合、Accountモデルのエラーをフォームオブジェクトのエラーに追加する必要はありません。

  # ¥ しかし、Account モデルの保存を試みなければ判断できないような他の検証エラー (データベース内の電子メールの一意性など) がある場合は、それらのエラーを Account モデルから RegisterForm オブジェクトに転送する必要があります。これは、RegisterFormがデータベースレベルの制約やAccountモデルに固有のその他の検証を知らないために必要です。
  # Validations
  # validates :password, presence: true, confirmation: true
  validates :password, presence: true, confirmation: true

  # Assuming the account model has all these attributes except for :password which is :hashed_password in the account model
  def form_save
    # ¥ フォームオブジェクトでvalidationさせるために必須! valid?
    # Ensures the form object is valid before proceeding.
    return false unless valid?

    # Builds the account object from the form data.
    account = build_account()

    # Attempts to save the account object to the database.
    #! 1. DB側のユニーク制約や account.rbに記述してあるvalidation処理で .saveが失敗する可能性がある。
    if account.save
      # Returns true if the account was saved successfully.
      true
    else
      # If the save fails, transfer the account errors back to the form object
      # and return false to indicate the save did not succeed.
      #! 2. 1で書いた要因でsaveできなかった場合、account.rb側のエラーメッセージを フォームオブジェクトに引き継ぎ、それらを画面上に表示する必要がある
      transfer_errors_from(account)
      false
    end
  end

  private

  def transfer_errors_from(account)
    # Add the error to the form object. The `error.attribute` gives you the attribute name,
    # and `error.message` gives you the associated message.
    #  ! 必要!! フォームオブジェクト(RegisterForm)は直接Accountモデルに関連付けられていないので、自動的にaccount.errorsを知ることはできません。したがって、ActiveRecordモデルと同じようにアクセスできるようにするには、手動でAccountオブジェクトのエラーをRegisterFormオブジェクトに追加する必要があります。
    account.errors.each do |error|
      self.errors.add(error.attribute, error.message)
    end
    puts("self.errors ::: #{self.errors}")
    # self.errors.messages
    # => {
    #      :email => ["has already been taken"],
    #      :name => ["can't be blank"],
    #      :password => ["doesn't match confirmation", "is too short (minimum is 6 characters)"]
    #    }
  end

  def build_account
    # Create a new account instance
    Account.new(
      name: name,
      name_kana: name_kana,
      email: email,
      tel: tel,
      # account.rb の hash_password_if_present でsaveする前に設定するため空白にする
      hashed_password:'',
      description: description,
      gender: gender,
      employment_type: employment_type,
      is_suspended: is_suspended,
      is_admin: is_admin,
      # ¥ virtual attributes
      password: password,
      password_confirmation: password_confirmation,
    )
  end

  # Hashes the password using bcrypt
  # def hash_password(password)
  #   puts("BCrypt::Password.create(password): #{BCrypt::Password.create(password)}")
  #   BCrypt::Password.create(password)
  # end
end
