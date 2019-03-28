# encoding: utf-8
class ProductCategory < ActiveRecord::Base
  belongs_to :parent, :class_name => 'ProductCategory'
  has_many :children, :class_name => 'ProductCategory', :foreign_key => :parent_id, :dependent => :destroy
  has_many :products, :class_name => 'Product'

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :grade, :in => [1, 2, 3]  # extensible for more grades

  before_validation :setup, :on => :create

  def to_api
    { :id => id, :name => name, :description => description, :grade => grade }
  end

  # find out first category from ancestor chain
  def first_category
    parent = self.parent
    parent.nil? ? self : parent.first_category
  end

  # friendly display for ancestor chain
  def name_breadcrumb
    ancestor_chain.reverse.join(' - ')
  end

  def ancestor_chain(crumbs=[])
    crumbs << name
    parent = self.parent
    parent.nil? ? crumbs : parent.ancestor_chain(crumbs)
  end

  private
  def setup
    self.grade ||= 1
  end
end
