class AddLoginStatusToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :login_status, :boolean, default: false
  end
end
