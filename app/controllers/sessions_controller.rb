class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to categories_path
    else
      flash[:error] = 'Incorrect email or password. Please Try again.'
      render :new
    end
  end
end
