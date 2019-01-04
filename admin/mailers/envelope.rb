# encoding: utf-8
Wonton::Admin.mailer :envelope do

  email :new do |email, subject, content|
    to email
    subject subject
    body content
    content_type :html
    via :sendmail
  end

end