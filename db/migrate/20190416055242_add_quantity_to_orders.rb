class AddQuantityToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :quantity, :integer
  end
end
