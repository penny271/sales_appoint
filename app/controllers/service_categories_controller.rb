# class ServiceCategoriesController < ApplicationController
class ServiceCategoriesController < Base
  def index
    @service_categories = ServiceCategory.all
  end

end
