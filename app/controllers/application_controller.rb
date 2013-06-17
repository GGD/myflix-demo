class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def require_user
    unless current_user
      flash[:info] = "Access reserved for members only. Please sign in first."
      redirect_to sign_in_path
    end
  end

  private

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
end