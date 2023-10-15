class CreateCommodityCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :commodity_categories do |t|
      t.string :name, null: false
      #Ex:- :null => false

      t.timestamps
    end
  end
end
