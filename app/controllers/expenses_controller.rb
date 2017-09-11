class ExpensesController < ApplicationController
  
  before_action :set_login
  before_action :set_expense, only: [:edit, :update, :show, :destroy]
  before_action :require_same_expense, only: [:edit, :update, :destroy]
  before_action :require_task_user, only: [:show]
  before_action :total_expense, only: [:index]

  def index
    @expenses = User.find(params[:user_id]).expenses.paginate(page: params[:page], per_page: 5)
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    if @expense.save
      flash[:success] = "Expense is succesfully created"
      redirect_to user_expenses_path(current_user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      flash[:success] = "Your expense has been updated successfully"
      redirect_to user_expenses_path(current_user)
    else
      render 'edit'
    end
  end

  def show

  end

  def destroy
    @expense.destroy
    flash[:danger] = "Expense have been deleted"
    redirect_to user_expenses_path(current_user)
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :value, :task_id)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def total_expense
    @total = 0
  end

  def set_login
    if !logged_in?
      flash[:danger] = "You must be logged in to perform the action"
      redirect_to root_path
    end
  end

  def require_task_user
    if !@expense.task.users.include?current_user and !current_user.admin?
      flash[:danger] = "You are not authorised to perform the action"
      redirect_to root_path
    end
  end

  def require_same_expense
    if current_user != @expense.user and !current_user.admin?
      flash[:danger] = "You can only edit your own expense"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_expense.admin?
      flash[:danger] = "Only admin can perform that action"
    end
  end

end