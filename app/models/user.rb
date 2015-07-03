class User < ActiveRecord::Base
  before_save :ensure_authentication_token
  enum role: [:guest, :admin]
  after_initialize :set_default_role, :if => :new_record?

  devise :database_authenticatable, :trackable, :token_authenticatable
  has_one :address
  has_many :orders

  def set_default_role
    self.role ||= :guest
  end


end
