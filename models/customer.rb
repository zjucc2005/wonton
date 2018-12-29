# encoding: utf-8
class Customer < ActiveRecord::Base
  has_many :product_access_logs, :class_name => 'ProductAccessLog', :dependent => :destroy

  validates_presence_of   :uid
  validates_uniqueness_of :uid
  validates_presence_of   :name

  before_validation :setup, :on => :create

  private
  def setup
    self.uid = get_unique_uid
  end

  def get_unique_uid
    new_uid = Account.new_token
    Customer.where(uid: new_uid).count > 0 ? get_unique_uid : new_uid
  end

end
