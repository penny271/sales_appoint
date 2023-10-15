# class CommodityCategoriesController < ApplicationController
class CommodityCategoriesController < Base
  def index
    @commodity_categories = CommodityCategory.all
  end

  def new
    if current_account
      @form = CommodityCategories::CreateForm.new
      # @commodity_form = CommodityCategory.new
      render action: 'new'
    end
  end


end
