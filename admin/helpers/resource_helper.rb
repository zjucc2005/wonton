# encoding: utf-8
module Wonton
  class Admin
    module ResourceHelper

      ##
      # Account
      #
      def load_account
        @account = Account.where(id: params[:id]).first
        halt(404) if @account.nil?
      end

      def account_params
        resource_params_permit(:account,
          %w[email nickname password password_confirmation role grade name sex year_of_birth month_of_birth day_of_birth
             mobile_phone telephone fax company company_addr department position website])
      end

      ##
      # Product Category
      #
      def load_product_category
        @product_category = ProductCategory.where(id: params[:id]).first
        halt(404) if @product_category.nil?
      end

      def product_category_params
        resource_params_permit(:product_category, %w[name name_en description description_en])
      end

      def load_main_categories
        @main_categories = ProductCategory.where(grade: 1).order(:created_at => :asc)
      end

      def load_category_options
         @category_options = ProductCategory.where(grade: [2, 3]).map{|category| [category.name_breadcrumb, category.id] }.sort
      end

      ##
      # Product
      #
      def load_product
        @product = Product.where(id: params[:id]).first
        halt(404) if @product.nil?
      end

      def product_params
        resource_params_permit(:product, %w[name name_en sku_code thumbnail description description_en size size_en material material_en price price_1 price_2 price_3 product_category_id])
      end

      ##
      # ProductPost
      #
      def load_product_post
        @product_post = ProductPost.where(id: params[:id]).first
        halt(404) if @product_post.nil?
      end

      def product_post_params
        resource_params_permit(:product_post, %w[image])
      end

      ##
      # MyMail
      def load_my_mail
        @my_mail = MyMail.where(id: params[:id]).first
        halt(404) if @my_mail.nil?
      end

      def my_mail_params
        resource_params_permit(:my_mail, %w[title content to_emails])
      end

      ##
      # Order
      def load_order
        @order = Order.where(id: params[:id]).first
        halt(404) if @order.nil?
      end

    end

    helpers ResourceHelper
  end
end