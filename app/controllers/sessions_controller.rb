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
    @form = LoginForm.new(params[:login_form])
    if @form.email.present?
      user = Account.find_by("LOWER(email) = ?", @form.email.downcase)
      # flash[:success] = "form successfully created"
      # redirect_to @form
    end
    if user
      # session[:id] = user.id
      # flash[:error] = "Something went wrong"
      # render 'new'
      redirect_to root_path
    else
      # render action: "new"
      # * For Rails and most Ruby code, it's a convention to use symbols where the value represents a name or identifier that won't change.
      render action: :new
    end
  end

end
