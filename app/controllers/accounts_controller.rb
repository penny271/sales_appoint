# class AccountsController < ApplicationController
class AccountsController < Base
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
    @account_form = RegisterForm.new(account_params)
    # render action: "new"
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