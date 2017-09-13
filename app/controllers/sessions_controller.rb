class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.login_status == true
        flash[:danger] = "You are already loggedin somewhere else"
        redirect_to root_path
      else
        user.login_status = true
        user.save
        session[:user_id] = user.id
        flash[:success] = "You have successfully logged in"
        redirect_to user_path(user)
      end
    else
      flash.now[:danger] = "Invalid login credentials"
      render 'new'
    end
  end

  def destroy
    current_user.login_status = false
    current_user.save
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out"
    redirect_to root_path
  end

end