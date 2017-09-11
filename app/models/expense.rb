class Expense < ActiveRecord::Base
  belongs_to :task
  belongs_to :user, optional: true
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end