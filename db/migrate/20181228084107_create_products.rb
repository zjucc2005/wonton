class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.bigint :pv
      t.bigint :author_id

      t.timestamps null: false
    end
  end
end
