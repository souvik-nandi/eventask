class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.string :title
      t.numeric :value, default: 0
      t.references :user
      t.references :task
      t.timestamps
    end
  end
end
