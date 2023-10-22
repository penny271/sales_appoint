# class ServiceCategoriesController < ApplicationController
class ServiceCategoriesController < Base
  # def index
  #   @service_categories = ServiceCategory.all
  # end


  # GET /commodity_categories
  def index
    # @service_categories = CommodityCategory.all
    # - commodity_categoriesに対してページネートできるようにする
    # @service_categories = CommodityCategory.page(params[:page])

    # `CommodityCategory.ransack`でCommodityCategoryに対してransackを使う
    # params[:q]には検索フォームで指定した検索条件が入る
    @search = ServiceCategory.ransack(params[:q])

    # デフォルトのソートをid降順にする
    @search.sorts = 'id desc' if @search.sorts.empty?

    # `@search.result`で検索結果となる@service_categoriesを取得する
    # 検索結果に対してはkaminariのpageメソッドをチェーンできる
    @service_categories = @search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)
  end

end
