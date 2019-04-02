# encoding: utf-8
class ProductCategory < ActiveRecord::Base
  belongs_to :parent, :class_name => 'ProductCategory'
  has_many :children, :class_name => 'ProductCategory', :foreign_key => :parent_id, :dependent => :destroy
  has_many :products, :class_name => 'Product'

  validates_presence_of :name, :name_en
  validates_uniqueness_of :name, :name_en, :case_sensitive => false
  validates_inclusion_of :grade, :in => [1, 2, 3]  # extensible for more grades

  before_validation :setup, :on => :create

  extend FieldLocale
  field_locale(:name, :description)

  def to_api
    { :id => id, :name => name, :name_en => name_en, :description => description, :description_en => description_en, :grade => grade }
  end

  # find out first category from ancestor chain
  def ancestor
    parent = self.parent
    parent.nil? ? self : parent.ancestor
  end

  # find out all categories inherited from self, exclude self
  def descendants_id
    self.children.map{|child| [child.id, child.descendants_id] }.flatten
  end

  # friendly display for ancestor chain
  def name_breadcrumb(delimiter=' - ', locale=I18n.locale)
    ancestor_chain([], locale).reverse.join(delimiter)
  end

  def ancestor_chain(crumbs=[], locale=I18n.locale)
    crumbs << name_locale(locale)
    parent = self.parent
    parent.nil? ? crumbs : parent.ancestor_chain(crumbs, locale)
  end

  private
  def setup
    self.grade ||= 1
  end
end
