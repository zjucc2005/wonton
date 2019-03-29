# encoding: utf-8
Wonton::App.controllers :orders, :map => 'orders' do
  get :new do
    @order = Order.new
    render :new
  end

  post :create do
    @order = Order.new(order_params)
    @order.account = current_account if logged_in?
    if @order.save
      flash[:success] = t(:submission_of_order_succeeded)
      redirect url(:products, :new_arrival)
    else
      flash.now[:error] = t(:submission_of_order_failed)
      render :new
    end
  end
end