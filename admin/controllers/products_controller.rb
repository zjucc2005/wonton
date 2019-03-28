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
    @title = 'New Product'
    load_category_options
    @product = Product.new
    render :new
  end

  post :create do
    @product = Product.new(product_params.merge(author: current_account))
    @product.price = @product.price_1

    if @product.save
      flash[:success] = '产品创建成功, 请继续添加产品展示图'
      params[:save_and_continue] ? redirect(url(:products, :edit, :id => @product.id)) : redirect(url(:products, :index))
    else
      flash.now[:error] = pat(:create_error, :model => 'product')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = 'Edit Product'
    load_category_options
    load_product
    render :edit
  end

  put :update, :map => ':id/update' do
    load_product
    if @product.update(product_params)
      @product.update(price: @product.price_1)
      flash[:success] = pat(:update_success, :model => 'product', :id =>  "#{params[:id]}")
      params[:save_and_continue] ?
        redirect(url(:products, :edit, :id => @product.id)):
        redirect(url(:products, :index))
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

  get :new_post, :map => ':id/new_post' do
    load_product
    @product.product_posts.create!
    redirect url(:products, :edit, :id => @product.id)
  end


end