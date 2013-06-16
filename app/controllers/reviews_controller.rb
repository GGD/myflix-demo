class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(video_params)
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def video_params
    params.
      require(:review).
      permit(:rating, :content, :video_id).
      merge(user: current_user)
  end
end 