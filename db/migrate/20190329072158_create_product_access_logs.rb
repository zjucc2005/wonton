class CreateProductAccessLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :product_access_logs do |t|
      t.references :account
      t.references :product

      t.timestamps null: false
    end
  end
end
