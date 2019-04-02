class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :account
      t.references :product
      t.string :status
      t.text :content

      t.timestamps null: false
    end
  end
end
