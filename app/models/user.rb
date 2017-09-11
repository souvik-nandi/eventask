class User < ActiveRecord::Base
  has_many :events, dependent: :nullify
  has_many :expenses, dependent: :nullify
  has_many :allocations, dependent: :destroy
  has_many :tasks, through: :allocations
  
  before_save { self.email = email.downcase }

  validates :fname, presence: true
  validates :lname, presence: true
  validates :username, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 3, maximum: 25}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  has_secure_password
end
