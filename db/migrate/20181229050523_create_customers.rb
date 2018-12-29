class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :uid
      t.string :name
      t.string :sex
      t.string :birthday
      t.string :mobile_phone
      t.string :telephone
      t.string :fax
      t.string :company
      t.string :company_addr
      t.string :department
      t.string :position
      t.string :email
      t.string :website

      t.timestamps null: false
    end
  end
end
