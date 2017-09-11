class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.string :title
      t.numeric :value, default: 0
      t.belongs_to :user, index: true
      t.belongs_to :task, index: true
      t.timestamps
    end
  end
end
