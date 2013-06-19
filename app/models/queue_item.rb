class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: true

  def self.by_position
    order(:position)
  end

  def self.reorder_position(id_with_order_hash)
    sorted_array = id_with_order_hash.sort_by { |h,v| v.to_i }
    (1..sorted_array.size).each do |position|
      id = sorted_array[position - 1].first
      queue_item = QueueItem.find(id)
      queue_item.update_attributes(position: position)
    end
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end 

  def category_name
    category.name
  end
end