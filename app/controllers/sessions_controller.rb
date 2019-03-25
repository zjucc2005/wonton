# encoding: utf-8
Wonton::App.controllers :sessions do

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      flash[:success] = t(:login_succeeded)
    else
      flash[:error] = t(:invalid_email_or_password)
    end
    redirect params[:back_url] || url(:home,:index)
  end

  delete :destroy do
    set_current_account(nil)
    flash[:success] = t(:logout_succeeded)
    redirect params[:back_url] || url(:home, :index)
  end
end