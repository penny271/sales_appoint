class CommodityCategories::NgCreateForm
  # ¥ ch1.8.2 ポイントは2つあります。1つは ActiveRecord::Base クラスを継承しないこと、もう1つは ActiveModel::Model を include することです。これで、 form_with の model オプションに指定できるようになります。 attr_accessor で定義している属性は、そのままフォームのフィールド名となります
  include ActiveModel::Model

  attr_accessor :name

  #^ 青木 ★要更新 - 20231018
  # - CommodityCategories::CreateForm class自体は .save メソッドを持たないため、
  # - 自作する必要あり
  def form_save
    # Logic to save the form data to the database
    # Example: Create a new commodity category
    @commodity_category = CommodityCategory.new(name: name)
    @commodity_category.save
  end
end
