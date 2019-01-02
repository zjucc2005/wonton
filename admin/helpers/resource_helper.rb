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

    end

    helpers ResourceHelper
  end
end