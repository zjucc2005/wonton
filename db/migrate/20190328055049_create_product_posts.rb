class CreateProductPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :product_posts do |t|
      t.references :product
      t.string :image

      t.timestamps null: false
    end
  end
end
