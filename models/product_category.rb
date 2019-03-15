# encoding: utf-8
class ProductCategory < ActiveRecord::Base
  has_many :children, :class_name => 'ProductCategory', :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => 'ProductCategory'

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :grade, :in => [1, 2]             # extensible for more grades

  before_validation :setup, :on => :create

  def to_api
    { :id => id, :name => name, :description => description }
  end

  private
  def setup
    self.grade ||= 1
  end
end
