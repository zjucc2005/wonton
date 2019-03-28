class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku_code
      t.text :description
      t.bigint :pv
      t.bigint :author_id
      t.string :thumbnail
      t.string :size
      t.string :material
      t.decimal :price, :precision => 10, :scale => 2

      t.timestamps null: false
    end
  end
end
