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
        resource_params_permit(:account, %w[email nickname password password_confirmation role])
      end

      ##
      # Product Category
      #
      def load_product_category
        @product_category = ProductCategory.where(id: params[:id]).first
        halt(404) if @product_category.nil?
      end

      def product_category_params
        resource_params_permit(:product_category, %w[name description])
      end

      def load_main_categories
        @main_categories = ProductCategory.where(grade: 1).order(:created_at => :desc)
      end

      ##
      # Product
      #
      def load_product
        @product = Product.where(id: params[:id]).first
        halt(404) if @product.nil?
      end

      def product_params
        resource_params_permit(:product, %w[name sku_code thumbnail description])
      end

      ##
      # Customer
      def load_customer
        @customer = Customer.where(id: params[:id]).first
        halt(404) if @customer.nil?
      end

      def customer_params
        resource_params_permit(:customer,
        %w[name sex birthday mobile_phone telephone fax company company_addr department position email website])
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

    end

    helpers ResourceHelper
  end
end