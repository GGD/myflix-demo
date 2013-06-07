class Video < ActiveRecord::Base
  belongs_to :category

  attr_accessible :description, :large_cover, :small_cover, :title, :category_id

  validates_presence_of :title, :description
end
