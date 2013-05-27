class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:videos).all
  end
end
