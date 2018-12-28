# encoding: utf-8
Wonton::Admin.controllers :sessions do
  get :new do
    render 'new'
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      flash[:success] = 'Login success'
      redirect url(:home, :index)
    else
      flash.now[:error] = 'Invalid email or password'
      render 'new'
    end
  end

  delete :destroy do
    set_current_account(nil)
    flash[:success] = 'Logout success'
    redirect url(:sessions, :new)
  end
end
