# encoding: utf-8
module Wonton
  class App
    module ResourcesHelper

      def load_main_categories
        @main_categories = ProductCategory.where(grade: 1).order(:created_at => :asc)
      end

      def load_product(product_id=:id)
        @product = Product.where(id: params[product_id]).first
        halt(404) if @product.nil?
      end

      def load_product_category
        @product_category = ProductCategory.where(id: params[:id]).first
        halt(404) if @product_category.nil?
      end

      def order_params
        resource_params_permit(:order, %w[content])
      end

    end

    helpers ResourcesHelper
  end
end