class TasksController < ApplicationController
  before_action :set_event
  before_action :set_task, only: [:edit, :update, :show, :destroy]
  before_action :set_toggle_task, only: [:completed_toggle]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy, :completed_toggle]
  before_action :require_event_user, only: [:new, :create]

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

  def completed_toggle
    @task.completed = true
    if @task.save
      redirect_to event_tasks_path
      flash[:success] = "Task is succesfully completed"
    end
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

    def set_toggle_task
      @task = Event.find(params[:event_id]).tasks.find(params[:task_id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :deadline)
    end

    def require_same_user
      if current_user != @task.user and !current_user.admin?
        flash[:danger] = "You can only edit or delete your own task"
        redirect_to event_tasks_path
      end 
    end

    def require_event_user
      if current_user != @event.user and !current_user.admin?
        flash[:danger] = "You are not authorized to perform the action"
        redirect_to event_tasks_path
      end 
    end
end