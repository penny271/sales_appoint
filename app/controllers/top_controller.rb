class TopController < Base
# class Admin::TopController < Admin::Base
  def index
    if current_account
      render action: "dashboard"
    else
      render action: "index"
    end
  end
end
