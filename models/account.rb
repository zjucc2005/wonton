# encoding: utf-8
class Account < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  has_many :products, :class_name => 'Product', :foreign_key => :author_id
  has_many :my_mails, :class_name => 'MyMail', :foreign_key => :author_id

  # collection_associations
  has_many :collection_associations, :class_name => 'CollectionAssociation', :dependent => :destroy
  has_many :collections, :class_name => 'Product', :through => :collection_associations, :source => :product

  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_inclusion_of    :role,     :in => %w[admin customer]

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  ##
  # This method is for authentication purpose.
  def self.authenticate(email, password)
    account = where('lower(email) = lower(?)', email.to_s.strip).first if email.present?
    account && account.has_password?(password.to_s.strip) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(password_digest) == password
  end

  # Examples:
  #     account.authenticated?(:confirmation,   'confirmation_token')
  #     account.authenticated?(:remember,       'remember_token')
  #     account.authenticated?(:reset_password, 'reset_password_token')
  def authenticated?(attribute, token)
    digest = self.try("#{attribute}_digest")
    return false if digest.nil?
    ::BCrypt::Password.new(digest) == token
  end

  # Generate a friendly string randomly to be used as token.
  # By default, length is 20 characters.
  def self.new_token(length = 20)
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end

  # Digest a specified string to be saved into database.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    value = ::BCrypt::Password.create(string, cost: cost)
    value.force_encoding(Encoding::UTF_8) if value.encoding == Encoding::ASCII_8BIT
  end

  private

  def encrypt_password
    self.password_digest = Account.digest(password)
  end

  def password_required
    password_digest.blank? || password.present?
  end
end
