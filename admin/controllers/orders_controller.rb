# encoding: utf-8
Wonton::Admin.controllers :orders, :map => 'orders' do
  get :index do
    query = Order.all
    query = query.where(status: params[:status]) if params[:status].present?
    @orders = query.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  get :process, :map => ':id/process' do
    load_order
    @order.is_reading
    render :process
  end

  put :close, :map => ':id/close' do
    load_order
    @order.update(status: 'closed')
    flash[:success] = 'Operation succeeded'
    redirect url(:orders, :process, :id => @order.id)
  end

  delete :destroy, :map => ':id/destroy' do
    load_order
    if @order.destroy
      flash[:success] = pat(:delete_success, :model => 'order', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'order')
    end
    redirect url(:orders, :index)
  end
end