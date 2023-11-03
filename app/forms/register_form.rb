class RegisterForm
  # ¥ ch1.8.2 ポイントは2つあります。1つは ActiveRecord::Base クラスを継承しないこと、もう1つは ActiveModel::Model を include することです。これで、 form_with の model オプションに指定できるようになります。 attr_accessor で定義している属性は、そのままフォームのフィールド名となります
  include ActiveModel::Model

  # * password が DBにはないカスタム属性 hashed_password化するために必要
  # * 同じパスワードが入力されているかを確認するため confirm_pasword 追加
  attr_accessor :name, :name_kana, :email, :tel, :password, :hashed_passowrd, :description, :gender, :employment_type, :is_suspended, :is_admin, :confirm_password, :test

  # Assuming the account model has all these attributes except for :password which is :hashed_password in the account model
  def form_save
    account = build_account()

    # Attempt to save the account instance to the database
    if account.save
      true # Return true if the save was successful
    else
      # self.errors.messages.merge!(account.errors.messages) # Merge the account model's errors into the form object's errors
      account.errors.each do |error|
        # Add the error to the form object. The `error.attribute` gives you the attribute name,
        # and `error.message` gives you the associated message.
        #  ! 不要だった。 なくてもエラーメッセージは表示された
        # self.errors.add(error.attribute, error.message)
        puts("error.attribute ::: #{error.attribute}")
        puts("error.message ::: #{error.message}")
      end

      false # Return false if the save was unsuccessful

    end
  end

  validate :passwords_match


  private
  def passwords_match
    puts("222 - password ::: #{password}")
    puts("222 - confirm_password ::: #{confirm_password}")
    puts("222 - name ::: #{name}")
    puts("222 - is_admin ::: #{is_admin}")
    puts("222 - test ::: #{test}")

    unless password == confirm_password
      puts("222 - passwordが一致しません。")
      errors.add(:confirm_password, "とパスワードが一致しません。")
    end
  end

  def build_account
    # Create a new account instance
    Account.new(
      name: name,
      name_kana: name_kana,
      email: email,
      tel: tel,
      hashed_password: hash_password(password), # You will define this method to hash the password
      description: description,
      gender: gender,
      employment_type: employment_type,
      is_suspended: is_suspended,
      is_admin: is_admin,
      # ¥ virtual attributes
      password: password,
      confirm_password: confirm_password,
      test: test
    )
  end

  # Hashes the password using bcrypt
  def hash_password(password)
    puts("BCrypt::Password.create(password): #{BCrypt::Password.create(password)}")
    BCrypt::Password.create(password)
  end
end
