# encoding: utf-8
class ProductAccessLog < ActiveRecord::Base
  belongs_to :product, :class_name => 'Product'
  belongs_to :customer, :class_name => 'Customer'

  validates_presence_of :product_id
  validates_presence_of :customer_id
end
