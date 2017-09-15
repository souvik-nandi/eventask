class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :flash_message, :multiple_flash

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end

  def restore_session
    session[:user_id] = nil
  end

  def flash_message(type, msg)
    flash[type] ||= []
    flash[type] << msg
  end

  def add_message(type, text)
    @messages ||= []
    @messages.push({type: type, text: text})
  end

  def set_logger
    if logged_in?
      flash[:danger] = "You are already logged in"
      redirect_to root_path
    end
  end

end
