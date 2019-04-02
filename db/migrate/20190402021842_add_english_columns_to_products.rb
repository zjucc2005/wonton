class AddEnglishColumnsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :name_en, :string
    add_column :products, :description_en, :text
    add_column :products, :size_en, :string
    add_column :products, :material_en, :string

    add_column :product_categories, :name_en, :string
    add_column :product_categories, :description_en, :string
  end
end
