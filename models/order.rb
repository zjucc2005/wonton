# encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :account, :class_name => 'Account'
  belongs_to :product, :class_name => 'Product'
  validates_inclusion_of :status, :in => %w[new readed closed]
  validates_presence_of :product_id
  validates_numericality_of :quantity, :greater_than => 0

  before_validation :setup, :on => :create

  def is_reading
    self.update(status: 'readed') if status == 'new'
  end

  private
  def setup
    self.status ||= 'new'
  end
end
