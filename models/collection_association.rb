# encoding: utf-8
class CollectionAssociation < ActiveRecord::Base
  belongs_to :account, :class_name => 'Account'
  belongs_to :product, :class_name => 'Product'
  validates_presence_of :account_id, :product_id
end
