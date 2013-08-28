class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to categories_path
      else
        flash[:error] = "Your account has been suspended, please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:error] = 'Incorrect email or password. Please Try again.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
