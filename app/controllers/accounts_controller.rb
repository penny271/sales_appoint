# class AccountsController < ApplicationController
class AccountsController < Base
  skip_before_action :authorize

  def index
    @accounts = Account.all
  end

  def show
  end

  def edit
  end

  def new
    @account_form = RegisterForm.new
    render action: "new"
  end

  def create
    # @form = LoginForm.new(params[:login_form])
    @form = RegisterForm.new(account_params)
    # if @form.email.present?
    #   account = Account.find_by("LOWER(email) = ?", @form.email.downcase)
    # end

    # ¥ 20231012 app/services を使っている
    if @form.form_save
      flash[:notice] = "アカウントを新規作成しました。"
      redirect_to login_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      puts("flash: #{flash.now[:alert]}")
      # render action: "new"
      # * For Rails and most Ruby code, it's a convention to use symbols where the value represents a name or identifier that won't change.
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end

  private def account_params
    # - <input type="text" name="register_form[email]" id="register_form_email">
    params.require(:register_form).permit(:name, :nam_kana, :email, :tel, :password, :description, :gender, :employment_type, :is_suspended, :is_admin)
  end
end