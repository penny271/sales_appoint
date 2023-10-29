require 'bcrypt'

class Authenticator
  def initialize(current_account)
    @current_account = current_account
    puts(" @current_account : #{@current_account}")
    puts(" @current_account.methods : #{@current_account.methods}")
  end

  def authenticate(raw_password)
    # すべての条件が満たされていれば true を返す
    @current_account && @current_account.is_suspended !=1 && @current_account.hashed_password && BCrypt::Password.new(@current_account.hashed_password) == raw_password
  end
end