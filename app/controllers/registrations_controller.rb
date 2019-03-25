# encoding: utf-8
Wonton::App.controllers :registrations do
  post :create do
    begin
      account = Account.create!(
        role: 'customer',
        email: params[:email].strip,
        password: params[:password].strip,
        password_confirmation: params[:password_confirmation].strip
      )
      set_current_account(account)
      flash[:success] = t(:signup_succeeded)
    rescue Exception => e
      flash[:error] = e.message
    end
    redirect params[:back_url] || url(:home, :index)
  end
end