class TopController < Base
  # class Admin::TopController < Admin::Base

  skip_before_action :authorize

  def index
    if current_account
      render action: "dashboard"
    else
      # render action: "index"
      redirect_to login_path
    end
  end
end
