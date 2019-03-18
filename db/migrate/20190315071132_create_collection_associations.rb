class CreateCollectionAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :collection_associations do |t|
      t.references :account
      t.references :product
    end
  end
end
