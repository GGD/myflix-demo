class User < ActiveRecord::Base
  has_many :reviews, order: "created_at DESC"
  has_many :queue_items, order: :position

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :full_name
  
  has_secure_password

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
end
