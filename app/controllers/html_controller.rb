class HtmlController < Base
  # skip_before_action :authorize


  private def service_categories_params
    # - <input type="text" name="login_form[email]" id="login_form_email">
    # params.require(:service_categories_create_form).permit(:name)
    # - form_withが作る キーを 下記に入力する
    # * 例:Parameters: {"service_category"=>{"name"=>"abc"}, "commit"=>"登録"}
    params.require(:service_category).permit(:name, :description, :price, :initial_cost, :img_url)
  end
end