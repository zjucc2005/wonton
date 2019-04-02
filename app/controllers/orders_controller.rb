# encoding: utf-8
Wonton::App.controllers :orders, :map => 'orders' do
  get :new do
    halt(404) unless logged_in?
    @order = Order.new
    load_product(:product_id)
    render :new
  end

  post :create do
    load_product(:product_id)
    @order = Order.new(order_params)
    @order.account = current_account
    @order.product = @product
    if @order.save
      flash[:success] = t(:submission_of_order_succeeded)
      redirect url(:products, :new_arrival)
    else
      flash.now[:error] = t(:submission_of_order_failed)
      render :new
    end
  end
end