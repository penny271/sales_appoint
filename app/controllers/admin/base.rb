class Admin::Base < ApplicationController
  private def current_admin_account
    if session[:id]
      @account ||= Account.find_by(id: session[:id])
    end
  end

  helper_method :current_admin_account

end