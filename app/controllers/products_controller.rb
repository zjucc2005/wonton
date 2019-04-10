# encoding: utf-8
Wonton::App.controllers :products, :map => '/products' do
  # 新品
  get :new_arrival do
    load_main_categories
    @products = Product.where('created_at >= ?', Time.now - 1.year).order(:created_at => :desc).paginate(:page => params[:page], :per_page => 8)
    render :new_arrival
  end

  # 收藏
  get :collections do
    load_main_categories
    @products = current_account.collections.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 8)
    render :collections
  end

  # 通用 - 按产品目录分, 此处 id 为 product_category_id
  get :category, :map => ':id/category' do
    load_product_category
    load_main_categories
    @products = Product.where(product_category_id: @product_category.descendants_id << @product_category.id).order(:created_at => :desc).
      paginate(:page => params[:page], :per_page => 8)
    render :category
  end

  # 加载产品详情 modal, remote: true
  get :showcase, :map => ':id/showcase' do
    begin
      load_product
      @product.pv_up
      current_account.product_access_logs.create(product_id: @product.id) if logged_in?
      html_content = partial :showcase_modal, :locals => { :product => @product }
      { :status => 'succ', :html => html_content }.to_json
    rescue Exception => e
      { :status => 'fail', :reason => e.message }.to_json
    end
  end

  # 收藏, remote: true
  post :collect, :map => ':id/collect' do
    begin
      load_product
      current_account.collection_associations.find_or_create_by(product_id: @product.id)
      html_content = partial :collect_btn, :locals => { :product => @product }
      { :status => 'succ', :html => html_content }.to_json
    rescue Exception => e
      { :status => 'fail', :reason => e.message }.to_json
    end
  end

  # 取消收藏, remote: true
  post :cancel_collect, :map => ':id/cancel_collect' do
    begin
      load_product
      current_account.collection_associations.find_by(product_id: @product.id).try(:destroy)
      html_content = partial :collect_btn, :locals => { :product => @product }
      { :status => 'succ', :html => html_content }.to_json
    rescue Exception => e
      { :status => 'fail', :reason => e.message }.to_json
    end
  end


end