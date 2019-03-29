# encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :account, :class_name => 'Account'
  validates_inclusion_of :status, :in => %w[new readed closed]

  before_validation :setup, :on => :create

  def is_reading
    self.update(status: 'readed') if status == 'new'
  end

  private
  def setup
    self.status ||= 'new'
  end
end
