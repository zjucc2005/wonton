# encoding: utf-8
require 'carrierwave/orm/activerecord'
class Product < ActiveRecord::Base
  belongs_to :author, :class_name => 'Account'
  belongs_to :product_category, :class_name => 'ProductCategory'

  # collection_associations
  has_many :collection_associations, :class_name => 'CollectionAssociation', :dependent => :destroy
  has_many :collectors, :class_name => 'Account', :through => :collection_associations, :source => :account
  has_many :product_access_logs, :class_name => 'ProductAccessLog', :dependent => :destroy

  has_many :product_posts, :class_name => 'ProductPost', :dependent => :destroy
  has_many :orders, :class_name => 'Order', :dependent => :destroy

  # Validations
  validates_presence_of :name
  validates_presence_of :sku_code
  validates_uniqueness_of :sku_code
  validates_presence_of :description
  validates_presence_of :author_id
  validates_numericality_of :pv, :greater_than_or_equal_to => 0

  mount_uploader :thumbnail, FileUploader

  before_validation :setup, :on => :create

  extend ::FieldLocale
  field_locale(:name, :description, :size, :material)

  ##
  # page view/page access count, increase pv by 1
  def pv_up
    self.update!(pv: pv + 1)
  end

  # 使用动态派发(Dynamic patch)预先生成实体方法, 便于实例的创建和更新
  # 例如 product.update(price_1: 10) 可直接使用
  # 使用幽灵方法(Ghost methods), 亦可使用 :price_1, :price_1= 等方法
  # 但不支持继承自 ActiveRecord::Base 的部分方法
  # Ghost methods 代码如下:
  # def method_missing(method_name, *args, &block)
  #     if method_name.to_s.match(/price_(\d+)=/)
  #       self.price_list[$1] = args[0].to_f
  #     elsif method_name.to_s.match(/price_(\d+)/)
  #       price_list[$1]
  #     else
  #       super
  #     end
  # end
  %w[1 2 3].each do |grade|
    define_method "price_#{grade}" do
      self.price_list[grade]
    end
    define_method "price_#{grade}=" do |val|
      self.price_list[grade] = val.to_f
    end
  end

  def price_grade(grade=nil)
    try(:"price_#{grade}") || price
  end

  private
  def setup
    self.pv ||= 0
  end
end
