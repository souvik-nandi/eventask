class TasksController < ApplicationController
  before_action :set_event
  before_action :set_task, only: [:edit, :update, :destroy, :show]
  before_action :set_toggle_task, only: [:expense, :completed, :allocation, :userallocate, :userdeallocate]
  before_action :set_expense, only: [:show]

  before_action :require_user
  before_action :require_task_users, only: [:completed, :expense]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:allocation, :userallocate, :userdeallocate]

  def index
    @tasks = @event.tasks.paginate(page: params[:page], per_page: 5)
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.event = @event
    @task.user = current_user
    if @task.save
      flash[:success] = "Task is succesfully created"
      redirect_to event_task_path(@event, @task)
    else
      render 'new'
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = "Task was sucessfully updated"
      redirect_to event_task_path(@event, @task)
    else
      render 'edit'
    end
  end

  def show
  end

  def expense
    @expenses = @task.expenses.paginate(page: params[:page], per_page: 5)
  end

  def completed
    @task.completed = true
    if @task.save!
      redirect_to user_tasks_path(current_user)
      flash[:success] = "Task is succesfully completed"
    else
      redirect_to user_tasks_path(current_user)
      flash[:warning] = "Operation not successful"
    end
  end

  def allocation
    @ausers = @task.users
    @dusers = User.where.not(id: @ausers.ids)
  end

  def userallocate
    @user = params[:user]
    @allocation = Allocation.new(task_id: @task.id, user_id: @user)
    if @allocation.save
      redirect_to event_task_allocation_path(@task.event, @task)
      flash[:success] = "#{User.find(@user).username} is succesfully added"
    else
      redirect_to event_task_allocation_path(@task.event, @task)
      flash[:warning] = "Operation not successful"
    end
  end

  def userdeallocate
    @user = params[:user]
    Allocation.where("task_id = :t AND user_id = :u", {t: @task.id, u: @user}).destroy_all
    redirect_to event_task_allocation_path(@task.event, @task)
    flash[:danger] = "#{User.find(@user).username} is succesfully removed"
  end

  def destroy
    @task.destroy
    flash[:danger] = "Task was successfully deleted"
    redirect_to event_tasks_path
  end

  private
  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_task
    @task = Event.find(params[:event_id]).tasks.find(params[:id])
  end

  def set_expense
    if @task.expenses
      @expense = @task.expenses.sum("value")
    else
      @expense = 0
    end
  end

  def set_toggle_task
    @task = Event.find(params[:event_id]).tasks.find(params[:task_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :deadline)
  end

  def require_task_users
    if !@task.users.include?current_user and !current_user.admin?
      flash[:danger] = "You are not authorised to perform the action"
      redirect_to event_tasks_path
    end 
  end

  def require_same_user
    if @task.user != current_user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own tasks"
      redirect_to event_tasks_path
    end 
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = "Admin permission required"
      redirect_to root_path
    end 
  end
end