class Video < ActiveRecord::Base
  attr_accessible :description, :large_cover, :small_cover, :title
end
