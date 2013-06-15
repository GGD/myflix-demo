class Category < ActiveRecord::Base
  has_many :videos
  
  validates_presence_of :name

  def recent_videos
    videos.last(6).reverse
  end
end
