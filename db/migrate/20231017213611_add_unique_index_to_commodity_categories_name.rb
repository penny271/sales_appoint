class AddUniqueIndexToCommodityCategoriesName < ActiveRecord::Migration[7.0]
  def change
    add_index :commodity_categories, :name, unique: true
  end
end
