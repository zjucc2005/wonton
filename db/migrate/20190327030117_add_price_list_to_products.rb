class AddPriceListToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :price_list, :jsonb, :default => {}
    add_column :products, :product_category_id, :bigint
  end
end
