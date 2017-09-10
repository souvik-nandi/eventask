class CreateUserTaskAllocations < ActiveRecord::Migration[5.1]
  def change
    create_table :allocations do |t|
      t.belongs_to :task, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
