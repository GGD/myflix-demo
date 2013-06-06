class Category < ActiveRecord::Base
  has_many :videos
  
  attr_accessible :name

  def recent_videos
    videos.last(6).reverse
  end
end
