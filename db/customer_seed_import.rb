# cd into project 'wonton'
# $ padrino c
# > load 'db/customer_seed_import.rb'
require 'roo'

# import basic data -----------------------------------------------
puts 'run customer_seed.xlsx start...'
file_name = 'customer_seed.xlsx'
file_path = "db/#{file_name}"

ActiveRecord::Base.transaction do
  begin
    xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)
    (2..xlsx.last_row).each do |i|
      company, name, email, mobile_phone, website = xlsx.row(i)
      next if Customer.where(name: name, mobile_phone: mobile_phone, company: company, email: email, website: website).count > 0
      Customer.create!(
        name: name,
        mobile_phone: mobile_phone,
        company: company,
        email: email,
        website: website
      )
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace
    raise 'DEBUG: import customer_seed.xlsx failure!'
  end
end
puts 'import customer_seed.xlsx success!'