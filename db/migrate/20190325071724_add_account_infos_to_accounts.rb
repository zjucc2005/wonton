class AddAccountInfosToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :uid, :string
    add_column :accounts, :name, :string
    add_column :accounts, :sex, :string
    add_column :accounts, :year_of_birth, :integer
    add_column :accounts, :month_of_birth, :integer
    add_column :accounts, :day_of_birth, :integer
    add_column :accounts, :mobile_phone, :string
    add_column :accounts, :telephone, :string
    add_column :accounts, :fax, :string
    add_column :accounts, :company, :string
    add_column :accounts, :company_addr, :string
    add_column :accounts, :department, :string
    add_column :accounts, :position, :string
    add_column :accounts, :website, :string
  end
end
