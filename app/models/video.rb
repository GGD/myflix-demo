class Video < ActiveRecord::Base
  belongs_to :category

  attr_accessible :description, :large_cover, :small_cover, :title, :category_id

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    Video.where('title LIKE ?', "%#{search_term}%")
  end
end
