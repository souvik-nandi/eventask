class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.belongs_to :user, index: true, optional: true
      t.timestamps
    end
  end
end