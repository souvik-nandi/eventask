class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :description, presence: true, length: {minimum: 10, maximum: 500}
  validates :deadline, presence: true
end