class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :deadline
      t.boolean :completed, default: false
      t.references :user
      t.references :event

      t.timestamps
    end
  end
end