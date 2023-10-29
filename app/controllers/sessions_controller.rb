# class SessionsController < ApplicationController
class SessionsController < Base
  skip_before_action :authorize

  def new
    if current_account
      redirect_to root_path
    else
      @form = LoginForm.new
      render action: "new"
    end
  end

  def create
    # @form = LoginForm.new(params[:login_form])
    @form = LoginForm.new(login_params)
    if @form.email.present?
      account = Account.find_by("LOWER(email) = ?", @form.email.downcase)
    end

    # ¥ 20231012 app/services を使っている
    if Authenticator.new(account).authenticate(@form.password)
      session[:id] = account.id
      flash[:notice] = "ログインしました。"
      redirect_to root_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      puts("flash: #{flash.now[:alert]}")
      # render action: "new"
      # * For Rails and most Ruby code, it's a convention to use symbols where the value represents a name or identifier that won't change.
      render action: :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:id)
    flash[:notice] = "ログアウトしました。"
    redirect_to root_path
  end

  private def login_params
    # - <input type="text" name="login_form[email]" id="login_form_email">
    params.require(:login_form).permit(:email, :password)
  end
end
