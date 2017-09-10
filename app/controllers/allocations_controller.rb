class AllocationsController < ApplicationController
  before_action :require_admin
  before_action :set_tasks
  before_action :set_users

  def index
  end

  private
    def allocation_params
      params.require(:allocation).permit(:task_id, :user_id)
    end

    def set_tasks
      @tasks = Task.all
    end

    def set_users
      @users = User.all
    end

    def require_admin
      if !logged_in? or !current_user.admin?
        flash[:danger] = "Admin permission required"
        redirect_to root_path
      end 
    end
end