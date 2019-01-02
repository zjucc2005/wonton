# encoding: utf-8
Wonton::Admin.controllers :products, :map => 'products' do

  get :index do
    @title = 'Products'
    query = Product.all
    %w[sku_code name].each do |field|
      query = query.where("#{field} LIKE ?", "%#{params[:"#{field}"].strip}%") if params[:"#{field}"].present?
    end
    @products = query.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  get :new do
    @title = pat(:new_title, :model => 'product')
    @product = Product.new
    render :new
  end

  post :create do
    @product = Product.new(product_params.merge(author: current_account))
    if @product.save
      @title = pat(:create_title, :model => "product #{@product.id}")
      flash[:success] = pat(:create_success, :model => 'product')
      params[:save_and_continue] ? redirect(url(:products, :index)) : redirect(url(:products, :edit, :id => @product.id))
    else
      @title = pat(:create_title, :model => 'product')
      flash.now[:error] = pat(:create_error, :model => 'product')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = pat(:edit_title, :model => "product #{params[:id]}")
    load_product
    render :edit
  end

  put :update, :map => ':id/update' do
    @title = pat(:update_title, :model => "product #{params[:id]}")
    load_product
    if @product.update(product_params)
      flash[:success] = pat(:update_success, :model => 'product', :id =>  "#{params[:id]}")
      params[:save_and_continue] ?
        redirect(url(:products, :index)) :
        redirect(url(:products, :edit, :id => @product.id))
    else
      flash.now[:error] = pat(:update_error, :model => 'product')
      render :edit
    end
  end

  delete :destroy, :map => ':id/destroy' do
    load_product
    if @product.destroy
      flash[:success] = pat(:delete_success, :model => 'product', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'product')
    end
    redirect url(:products, :index)
  end

  get :thumbnail_url, :map => ':id/thumbnail' do
    load_product
    if @product.thumbnail.present?
      file_path = @product.thumbnail.path
      send_file(file_path, :file_name => File.basename(file_path))
    else
      halt 404
    end
  end
end