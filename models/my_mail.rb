# encoding: utf-8
class MyMail < ActiveRecord::Base
  belongs_to :author, :class_name => 'Account'
  has_many :mail_tasks, :class_name => 'MailTask'

  validates_presence_of :title
  validates_presence_of :content
  validates_inclusion_of :status, :in => %w[new sending finished]
  validates_presence_of :author

  before_validation :setup, :on => :create

  STATUS = {
    :new => '编辑中',
    :sending => '发送中',
    :finished => '已完成'
  }.stringify_keys

  def status_cn
    STATUS[status] || status
  end

  def can_edit?
    status == 'new'
  end

  # 外层事务
  def deliver
    to_emails.each do |email|
      if self.mail_tasks.where(to_email: email).count == 0
        self.mail_tasks.create!(to_email: email)
      end
    end
    self.update!(status: 'sending')
  end

  # 发送完所有邮件后更新状态
  def update_status
    if mail_tasks.count > 0 && mail_tasks.where(status: 'init').count == 0
      self.update(status: 'finished')
    end
  end

  private
  def setup
    self.status ||= 'new'
    self.to_emails ||= []
  end

end
