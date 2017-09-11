class Task < ActiveRecord::Base
  belongs_to :event
  has_many :allocations, dependent: :destroy
  has_many :users, through: :allocations
  belongs_to :user, optional: true
  has_many :expenses, dependent: :destroy
  
  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :description, presence: true, length: {minimum: 10, maximum: 500}
  validates :deadline, presence: true
end