class AddImgUrlToServiceCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :service_categories, :img_url, :text
  end
end
