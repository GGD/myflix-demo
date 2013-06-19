class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, order: :position

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :full_name
  has_secure_password
end
