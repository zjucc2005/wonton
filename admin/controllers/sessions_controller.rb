# encoding: utf-8
Wonton::Admin.controllers :sessions do
  get :new do
    render 'new'
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      flash[:success] = t(:login_succeeded)
      redirect url(:home, :index)
    else
      flash.now[:error] = t(:invalid_email_or_password)
      render 'new'
    end
  end

  delete :destroy do
    set_current_account(nil)
    flash[:success] = t(:logout_succeeded)
    redirect url(:sessions, :new)
  end
end
