# encoding: utf-8
Wonton::App.controllers :sessions do

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      flash[:success] = 'Login success'
      redirect params[:back_url] || url(:home,:index)
    else
      # refactored
      flash.now[:error] = 'Invalid email or password'
      render 'new'
    end
  end

  delete :destroy do
    set_current_account(nil)
    flash[:success] = 'Logout success'
    redirect params[:back_url] || url(:home, :index)
  end
end