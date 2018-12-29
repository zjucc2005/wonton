# encoding: utf-8
Wonton::Admin.mailer :products do

  email :new do |email, product, customer|
    from 'info@quaie.com'
    to email
    subject 'New Product'
    locals :product => product, :customer => customer
    render 'products/new'
    content_type :html
    via :sendmail
  end

end