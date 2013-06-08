class CategoriesController < ApplicationController
  def index
    unless current_user
      flash[:info] = "Access reserved for members only. Please sign in first."
      redirect_to root_path
    end
    @categories = Category.includes(:videos).all
  end

  def show
    @category = Category.find(params[:id])
    @videos = @category.videos.all
  end
end
