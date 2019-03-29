# encoding: utf-8
module Wonton
  class App
    module ResourcesHelper

      def load_main_categories
        @main_categories = ProductCategory.where(grade: 1).order(:created_at => :asc)
      end

      def load_product
        @product = Product.where(id: params[:id]).first
        halt(404) if @product.nil?
      end

      def load_product_category
        @product_category = ProductCategory.where(id: params[:id]).first
        halt(404) if @product_category.nil?
      end

    end

    helpers ResourcesHelper
  end
end