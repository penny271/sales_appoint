class RegisterForm
  # ¥ ch1.8.2 ポイントは2つあります。1つは ActiveRecord::Base クラスを継承しないこと、もう1つは ActiveModel::Model を include することです。これで、 form_with の model オプションに指定できるようになります。 attr_accessor で定義している属性は、そのままフォームのフィールド名となります
  include ActiveModel::Model

  # * password が DBにはないカスタム属性 hashed_password化するために必要
  attr_accessor :name, :name_kana, :email, :tel, :password, :hashed_passowrd, :description, :gender, :employment_type, :is_suspended, :is_admin

  # Assuming the account model has all these attributes except for :password which is :hashed_password in the account model
  def form_save
    # Create a new account instance
    account = Account.new(
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
    )

    # Attempt to save the account instance to the database
    if account.save
      true # Return true if the save was successful
    else
      self.errors.messages.merge!(account.errors.messages) # Merge the account model's errors into the form object's errors
      false # Return false if the save was unsuccessful
    end
  end

  private

  # Hashes the password using bcrypt
  def hash_password(password)
    puts("BCrypt::Password.create(password): #{BCrypt::Password.create(password)}")
    BCrypt::Password.create(password)
  end
end
