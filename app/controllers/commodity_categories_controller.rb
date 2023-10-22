# class CommodityCategoriesController < ApplicationController
class CommodityCategoriesController < Base

  # GET /commodity_categories
  def index
    # @commodity_categories = CommodityCategory.all
    # - commodity_categoriesに対してページネートできるようにする
    # @commodity_categories = CommodityCategory.page(params[:page])

    # `CommodityCategory.ransack`でCommodityCategoryに対してransackを使う
    # params[:q]には検索フォームで指定した検索条件が入る
    @search = CommodityCategory.ransack(params[:q])

    # デフォルトのソートをid降順にする
    @search.sorts = 'id desc' if @search.sorts.empty?

    # `@search.result`で検索結果となる@commodity_categoriesを取得する
    # 検索結果に対してはkaminariのpageメソッドをチェーンできる
    @commodity_categories = @search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)
  end

  # GET /commodity_category/1
  def show
    # ! @cat がここにはないが、before_action :set_cat, only: %i[ show edit update destroy ] で設定されているため使うことができる
    @commodity_category = CommodityCategory.find(params[:id])
    puts("show: @commodity_category::: #{@commodity_category}")
  end

  def new
    if current_account
      # @form = CommodityCategories::CreateForm.new
      @commodity_category = CommodityCategory.new
      render action: 'new'
    end
  end

  def edit
    @commodity_category = CommodityCategory.find(params[:id])
  end

  def create
    # . @form = CommodityCategories::CreateForm.new(params[:name])
    # . @form = CommodityCategories::CreateForm.new(commodity_categories_params)
    #   # - CommodityCategories::CreateForm class自体は .save メソッドを持たないため、create_form.rbで saveと同じロジックを自作する必要あり
    # if @form.form_save
    @commodity_category = CommodityCategory.new(commodity_categories_params)
    if @commodity_category.save
      # flash[:success] = "CommodityCategories successfully created"
      flash.now.notice = "CommodityCategories successfully created"
      # redirect_to "/commodity_categories"
      #^ 青木 ★要更新 - 20231018
      # respond_to do |format|
      #   format.turbo_stream
      #   format.html { redirect_to "/commodity_categories" }
      # end
      # - フォームがTurboを使用するように設定され、アクション内で応答フォーマットまたはリダイレクトを指定しない場合、Turboのデフォルトの動作はTurbo Stream応答を探すことです。見つからない場合は、次の論理ビューに対応するHTMLレスポンスを期待します。createアクションのコンテキストでは、これは通常、新しく作成されたリソースのshowビューを意味します。
    else
      flash.now.alert = "Something went wrong(create)"
      render 'new', status: :unprocessable_entity
    end
  end

  # ¥ 後で対応
  def update
    @commodity_category = CommodityCategory.find(params[:id])
    if @commodity_category.update(commodity_categories_params)
      puts("update: @commodity_category::: #{@commodity_category}")

      # render action: 'show'
      flash.now.notice = "CommodityCategory was successfully updated"
      # redirect_to @commodity_category
    else
      flash.now.alert = "Something went wrong(update)"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @commodity_category = CommodityCategory.find(params[:id])
    puts("params[:id];;;; #{params[:id]}")
    if @commodity_category.destroy
      flash.now.notice = 'Object was successfully deleted.'
      # redirect_to commodity_cateogrys_url
    else
      flash.now.alert = 'Something went wrong(destroy)'
      render :show, status: :unprocessable_entity
    end
  end

  private def commodity_categories_params
    # - <input type="text" name="login_form[email]" id="login_form_email">
    # params.require(:commodity_categories_create_form).permit(:name)
    # - form_withが作る キーを 下記に入力する
    # * 例:Parameters: {"commodity_category"=>{"name"=>"abc"}, "commit"=>"登録"}
    params.require(:commodity_category).permit(:name)
  end


end
