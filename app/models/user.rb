class User < ActiveRecord::Base
  include Tokenable

  has_many :reviews, order: "created_at DESC"
  has_many :queue_items, order: :position
  has_many :following_relationships, class_name: Relationship, foreign_key: :follower_id
  has_many :leading_relationships, class_name: Relationship, foreign_key: :leader_id
  has_many :payments

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :full_name

  has_secure_password

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def follow?(leader)
    following_relationships.map(&:leader).include? leader
  end

  def follow(leader)
    following_relationships.create(leader: leader) if can_follow?(leader)
  end

  def can_follow?(leader)
    !(follow?(leader) || self == leader)
  end

  def deactivate!
    update_column(:active, false)
  end
end
