class UsersController < ApplicationController

  before_action :require_user, except: [:new, :create]
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to EvenTasks #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    if logged_in? && current_user == @user
      @user.tasks.each do |task|
        if task.deadline < Time.now and !task.completed
          if flash.now[:danger]
            flash.now[:danger] += "<br><br><b>#{task.title}</b> is due on #{task.deadline}"
          else
            flash.now[:danger] = "<b>#{task.title}</b> is due on #{task.deadline}"
          end
        end
      end
    end
    @user_events = @user.events.paginate(page: params[:page], per_page: 5)
  end

  def tasks
    @tasks = current_user.tasks
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      restore_session
    end
    @user.destroy
    flash[:danger] = "User and all events created by user have been deleted"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:fname, :lname, :username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admin users can perform that action"
    end
  end

end