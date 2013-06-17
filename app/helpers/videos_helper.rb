module VideosHelper
  def add_queue_btn(video)
    link_to("+ My Queue", queue_items_path(video_id: @video.id), method: :post, class: 'btn') unless current_user_queued_video?(video)
  end

  private

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end
