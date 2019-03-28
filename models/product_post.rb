# encoding: utf-8
class ProductPost < ActiveRecord::Base
  belongs_to :product, :class_name => 'Product'
  mount_uploader :image, FileUploader
end
