class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, order: 'created_at DESC'
  has_many :queue_items

  attr_accessible :description, :large_cover, :small_cover, :title, :category_id

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('title LIKE ?', "%#{search_term}%")
  end

  def average_rating
    rating_array = reviews.group(:user_id).map(&:rating)
    (rating_array.sum.to_f / rating_array.size).round(1)
  end
end
