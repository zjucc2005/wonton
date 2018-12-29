# encoding: utf-8
Wonton::Admin.controllers :customers, :map => 'customers' do

  get :index do
    @title = 'Customers'
    query = Customer.all
    %w[sex].each do |field|
      query = query.where(:"#{field}" => params[:"#{field}"].strip) if params[:"#{field}"].present?
    end
    %w[name birthday mobile_phone telephone fax company company_addr department position email website].each do |field|
      query = query.where("#{field} LIKE ?", "%#{params[:"#{field}"].strip}%") if params[:"#{field}"].present?
    end
    @customers = query.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  get :new do
    @title = pat(:new_title, :model => 'customer')
    @customer = Customer.new
    render :new
  end

  post :create do
    @customer = Customer.new(customer_params)
    if @customer.save
      @title = pat(:create_title, :model => "customer #{@customer.id}")
      flash[:success] = pat(:create_success, :model => 'customer')
      params[:save_and_continue] ? redirect(url(:customers, :index)) : redirect(url(:customers, :edit, :id => @customer.id))
    else
      @title = pat(:create_title, :model => 'customer')
      flash.now[:error] = pat(:create_error, :model => 'customer')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = pat(:edit_title, :model => "customer #{params[:id]}")
    load_customer
    render :edit
  end

  put :update, :map => ':id/update' do
    @title = pat(:update_title, :model => "customer #{params[:id]}")
    load_customer
    if @customer.update(customer_params)
      flash[:success] = pat(:update_success, :model => 'customer', :id =>  "#{params[:id]}")
      params[:save_and_continue] ?
        redirect(url(:customers, :index)) :
        redirect(url(:customers, :edit, :id => @customer.id))
    else
      flash.now[:error] = pat(:update_error, :model => 'customer')
      render :edit
    end
  end

  delete :destroy, :map => ':id/destroy' do
    load_customer
    if @customer.destroy
      flash[:success] = pat(:delete_success, :model => 'customer', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'customer')
    end
    redirect url(:customers, :index)
  end
end