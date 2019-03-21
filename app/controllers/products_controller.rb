# encoding: utf-8
Wonton::App.controllers :products, :map => '/products' do
  get :index do
    'products/index.html route ok!'
  end

  get :new_arrival do
    @products = Product.all.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 1)
    render :new_arrival
  end

  get :collections do
    'url(:products, :collections) route ok!'
  end
end