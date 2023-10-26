# class ServiceCategoriesController < ApplicationController
class ServiceCategoriesController < Base
  # def index
  #   @service_categories = ServiceCategory.all
  # end

  # GET /service_categories
  def index
    # @service_categories = ServiceCategory.all
    # - service_categoriesに対してページネートできるようにする
    # @service_categories = ServiceCategory.page(params[:page])

    # `ServiceCategory.ransack`でServiceCategoryに対してransackを使う
    # params[:q]には検索フォームで指定した検索条件が入る
    @search = ServiceCategory.ransack(params[:q])

    # デフォルトのソートをid降順にする
    @search.sorts = 'id desc' if @search.sorts.empty?

    # `@search.result`で検索結果となる@service_categoriesを取得する
    # 検索結果に対してはkaminariのpageメソッドをチェーンできる
    @service_categories = @search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)
  end

  # GET /service_category/1
  def show
    # ! @cat がここにはないが、before_action :set_cat, only: %i[ show edit update destroy ] で設定されているため使うことができる
    @service_category = ServiceCategory.find(params[:id])
    puts("show: @service_category::: #{@service_category}")
  end

  def new
    return unless current_account

    # @form = CommodityCategories::CreateForm.new
    @service_category = ServiceCategory.new
    render action: 'new'
  end

  def edit
    @service_category = ServiceCategory.find(params[:id])
  end

  def create
    # . @form = CommodityCategories::CreateForm.new(params[:name])
    # . @form = CommodityCategories::CreateForm.new(service_categories_params)
    #   # - CommodityCategories::CreateForm class自体は .save メソッドを持たないため、create_form.rbで saveと同じロジックを自作する必要あり
    # if @form.form_save
    @service_category = ServiceCategory.new(service_categories_params)
    if @service_category.save
      # flash[:success] = "CommodityCategories successfully created"
      flash.now.notice = 'CommodityCategories successfully created'
      # redirect_to "/service_categories"
      # ^ 青木 ★要更新 - 20231018
      # respond_to do |format|
      #   format.turbo_stream
      #   format.html { redirect_to "/service_categories" }
      # end
      # - フォームがTurboを使用するように設定され、アクション内で応答フォーマットまたはリダイレクトを指定しない場合、Turboのデフォルトの動作はTurbo Stream応答を探すことです。見つからない場合は、次の論理ビューに対応するHTMLレスポンスを期待します。createアクションのコンテキストでは、これは通常、新しく作成されたリソースのshowビューを意味します。
    else
      flash.now.alert = 'Something went wrong(create)'
      render 'new', status: :unprocessable_entity
    end
  end

  # ¥ 後で対応
  def update
    @service_category = ServiceCategory.find(params[:id])
    if @service_category.update(service_categories_params)
      puts("update: @service_category::: #{@service_category}")

      # render action: 'show'
      flash.now.notice = 'ServiceCategory was successfully updated'
      # redirect_to @service_category
    else
      flash.now.alert = 'Something went wrong(update)'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service_category = ServiceCategory.find(params[:id])
    puts("params[:id];;;; #{params[:id]}")
    if @service_category.destroy
      flash.now.notice = 'Object was successfully deleted.'
      # redirect_to service_cateogrys_url
    else
      flash.now.alert = 'Something went wrong(destroy)'
      render :show, status: :unprocessable_entity
    end
  end

  private def service_categories_params
    # - <input type="text" name="login_form[email]" id="login_form_email">
    # params.require(:service_categories_create_form).permit(:name)
    # - form_withが作る キーを 下記に入力する
    # * 例:Parameters: {"service_category"=>{"name"=>"abc"}, "commit"=>"登録"}
    params.require(:service_category).permit(:name, :description, :price, :initial_cost, :img_url)
  end
end
