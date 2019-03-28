# encoding: utf-8
Wonton::Admin.controllers :product_posts, :map => 'product_posts' do

  put :update, :map => ':id/update' do
    load_product_post
    if @product_post.update(product_post_params)
      flash[:success] = 'succeeded'
    else
      flash[:error] = 'failed'
    end
    redirect url(:products, :edit, :id => @product_post.product.id)
  end

  delete :destroy, :map => ':id/destroy' do
    load_product_post
    if @product_post.destroy
    else
    end
    redirect url(:products, :edit, :id => @product_post.product.id)
  end

end