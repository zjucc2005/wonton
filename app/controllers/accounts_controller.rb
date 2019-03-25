# encoding: utf-8
Wonton::App.controllers :accounts, :map => '/accounts' do

  get :edit_my_account do
    begin
      if logged_in?
        @account = current_account
        render :edit_my_account
      else
        raise 'error'
      end
    rescue Exception => e
      flash[:error] = e.message
      redirect url(:home, :index)
    end
  end

  put :update_my_account do
    begin
      if logged_in?
        'url(:accounts, :edit_my_account)'
      else
        raise 'not logged in'
      end
    rescue Exception => e
      flash[:error] = e.message
      redirect url(:home, :index)
    end
  end

  get :existed do
    begin
      raise 'invalid params' if params[:email].blank?
      account = Account.where(email: params[:email].strip).first
      { status: 'succ', existed: !account.nil? }.to_json
    rescue Exception => e
      { status: 'fail', reason: e.message }.to_json
    end
  end
end