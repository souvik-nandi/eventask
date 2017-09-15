class RemoveLoginStatusFromUsers < ActiveRecord::Migration[5.1]
  def change
  	remove_column :users, :login_status
  end
end
