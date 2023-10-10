# class SessionsController < ApplicationController
class SessionsController < Base
  def new
    if current_account
      redirect_to root_path
    else
      @form = LoginForm.new
      render action: 'new'
    end
  end

  def create
    # @form = LoginForm.new(params[:login_form])
    @form = LoginForm.new(login_params)
    if @form.email.present?
      account = Account.find_by("LOWER(email) = ?", @form.email.downcase)
      # flash[:success] = "form successfully created"
      # redirect_to @form
    end
    if account
      session[:id] = account.id
      # flash[:error] = "Something went wrong"
      # render 'new'
      redirect_to root_path
    else
      # render action: "new"
      # * For Rails and most Ruby code, it's a convention to use symbols where the value represents a name or identifier that won't change.
      render action: :new
    end
  end

  def destroy
    session.delete(:id)
    redirect_to root_path
  end


  private def login_params
    # - <input type="text" name="login_form[email]" id="login_form_email">
    params.require(:login_form).permit(:email, :password)
  end

end
