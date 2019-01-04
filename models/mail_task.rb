# encoding: utf-8
class MailTask < ActiveRecord::Base
  belongs_to :my_mail, :class_name => 'MyMail'

  validates_presence_of :my_mail_id
  validates_presence_of :to_email
  validates_inclusion_of :status, :in => %w[init succ fail]
  validates_numericality_of :retry_limit, :greater_than_or_equal_to => 0

  before_validation :setup, :on => :create

  class << self

    ##
    # 后台执行发送邮件任务 per 1min
    # 参数 limit 为每次发送邮件数
    def run(limit = 1)
      # mail_tasks running code here
      run_batch = Time.now.strftime('%Y%m%d%H%M%S')
      mail_tasks = MailTask.where(status: 'init', run_batch: nil).order(:retry_limit => :desc, :created_at => :asc).limit(limit)
      mail_tasks.update_all(run_batch: run_batch)
      MailTask.where(run_batch: run_batch).map(&:send_mail)
    end
  end

  def send_mail
    begin
      ::Wonton::Admin.deliver(:envelope, :new, to_email, my_mail.title, my_mail.content)
      self.update(status: 'succ')
    rescue Exception => e
      puts "SEND MAIL ERROR: #{e.message}"
      self.retry_limit -= 1
      self.status = 'fail' if self.retry_limit == 0
      self.save
    ensure
      self.update(run_batch: nil)
      self.my_mail.update_status
    end
  end

  private
  def setup
    self.status ||= 'init'
    self.retry_limit ||= 3
  end
end
