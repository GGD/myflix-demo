class User < ActiveRecord::Base
  attr_accessible :email, :full_name, :password

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :full_name
  has_secure_password
end
