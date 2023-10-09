class Base < ApplicationController
  private def current_account
    if session[:id]
      @account ||= Account.find_by(id: session[:id])
    end
  end

  helper_method :current_account

end