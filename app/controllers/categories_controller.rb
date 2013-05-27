class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:videos).all
  end

  def show
    @category = Category.find(params[:id])
    @videos = @category.videos.all
  end
end
