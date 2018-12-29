# encoding: utf-8
Wonton::Admin.controllers :accounts, :map => 'accounts' do

  get :index do
    @title = 'Accounts'
    query = Account.all
    @accounts = query.order(:created_at => :asc).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  get :new do
    @title = pat(:new_title, :model => 'account')
    @account = Account.new
    render :new
  end

  post :create do
    @account = Account.new(account_params)
    if @account.save
      @title = pat(:create_title, :model => "account #{@account.id}")
      flash[:success] = pat(:create_success, :model => 'account')
      params[:save_and_continue] ? redirect(url(:accounts, :index)) : redirect(url(:accounts, :edit, :id => @account.id))
    else
      @title = pat(:create_title, :model => 'account')
      flash.now[:error] = pat(:create_error, :model => 'account')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = pat(:edit_title, :model => "account #{params[:id]}")
    load_account
    render :edit
  end

  put :update, :map => ':id/update' do
    @title = pat(:update_title, :model => "account #{params[:id]}")
    load_account
    if @account.update(account_params)
      flash[:success] = pat(:update_success, :model => 'account', :id =>  "#{params[:id]}")
      params[:save_and_continue] ?
        redirect(url(:accounts, :index)) :
        redirect(url(:accounts, :edit, :id => @account.id))
    else
      flash.now[:error] = pat(:update_error, :model => 'account')
      render :edit
    end
  end

  delete :destroy, :map => ':id/destroy' do
    load_account
    if @account != current_account && @account.destroy
      flash[:success] = pat(:delete_success, :model => 'account', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'account')
    end
    redirect url(:accounts, :index)
  end
end
