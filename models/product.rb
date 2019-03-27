# encoding: utf-8
require 'carrierwave/orm/activerecord'
class Product < ActiveRecord::Base
  belongs_to :author, :class_name => 'Account'

  # collection_associations
  has_many :collection_associations, :class_name => 'CollectionAssociation', :dependent => :destroy
  has_many :collectors, :class_name => 'Account', :through => :collection_associations, :source => :account

  # Validations
  validates_presence_of :name
  validates_presence_of :sku_code
  validates_uniqueness_of :sku_code
  validates_presence_of :description
  validates_presence_of :author_id
  validates_numericality_of :pv, :greater_than_or_equal_to => 0

  mount_uploader :thumbnail, FileUploader

  before_validation :setup, :on => :create

  ##
  # page view/page access count, increase pv by 1
  def pv_up
    self.update!(pv: pv + 1)
  end

  private
  def setup
    self.pv ||= 0
  end
end
