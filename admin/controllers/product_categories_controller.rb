# encoding: utf-8
Wonton::Admin.controllers :product_categories, :map => 'product_categories' do

  get :index do
    @title = 'Product Categories'
    load_main_categories
    render :index
  end

  get :new do
    @title = 'New Product Category'
    @product_category = ProductCategory.new
    @parent = ProductCategory.where(id: params[:parent_id]).first
    render :new
  end

  post :create do
    @product_category = ProductCategory.new(product_category_params)
    @parent = ProductCategory.where(id: params[:parent_id]).first
    if @parent
      @product_category.grade  = @parent.grade + 1
      @product_category.parent = @parent
    end
    if @product_category.save
      flash[:success] = pat(:create_success, :model => 'product category')
      params[:save_and_continue] ?
        redirect(url(:product_categories, :new, :parent_id => @parent.try(:id))) :
        redirect(url(:product_categories, :index))
    else
      flash.now[:error] = pat(:create_error, :model => 'product category')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = 'Edit Product Category'
    load_product_category
    load_main_categories
    @parent = @product_category.parent
    render :edit
  end

  put :update, :map => ':id/update' do
    load_product_category
    @parent = ProductCategory.where(id: params[:product_category][:parent_id], grade: 1).first
    update_params = @parent && @product_category.grade == 2 ?
      product_category_params.merge({parent_id: @parent.id}) : product_category_params
    if @product_category.update(update_params)
      flash[:success] = pat(:update_success, :model => 'product category', :id =>  "#{params[:id]}")
      params[:save_and_continue] ?
        redirect(url(:product_categories, :edit, :id => @product_category.id)) :
        redirect(url(:product_categories, :index))
    else
      flash[:error] = pat(:update_error, :model => 'product category')
      render :edit
    end
  end

  delete :destroy, :map => ':id/destroy' do
    load_product_category
    if @product_category.destroy
      flash[:success] = pat(:delete_success, :model => 'product category', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'product category')
    end
    redirect url(:product_categories, :index)
  end

  # format - :html, :data(default)
  get :children, :map => ':id/children' do
    begin
      load_product_category
      @sub_categories = @product_category.children.order(:created_at => :asc)
      if params[:remote] == 'true'
        html_content = @sub_categories.map{|category| partial :list_unit, :locals => { :category => category} }.join('')
        html_content += partial :list_unit_plus, :locals => { :category => @product_category }
        { :status => 'succ', :parent => @product_category.to_api, :children => @sub_categories.map(&:to_api), :html => html_content }.to_json
      else
        { :status => 'succ', :parent => @product_category.to_api, :children => @sub_categories.map(&:to_api) }.to_json
      end
    rescue Exception => e
      { :status => 'fail', :reason => e.message }.to_json
    end
  end

end