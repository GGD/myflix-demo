class VideosController < ApplicationController
  before_filter :require_user
  
  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @search_term = params[:search_term]
    @videos = Video.search_by_title(@search_term)
  end
end
