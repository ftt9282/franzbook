class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :active_relationships, class_name:  "Friendship",
                                  foreign_key: "active_user_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Friendship",
                                  foreign_key: "passive_user_id",
                                  dependent:   :destroy
  has_many :friend_requests, through: :active_relationships, source: :passive_user
  has_many :pending_requests, through: :passive_relationships, source: :active_user
  
  # Sends a friend request to another user
  def send_friend_request(other_user)
    friend_requests << other_user
  end

  # Returns an array of users who offered the current user a friend request
  def pending_friends
  	self.passive_relationships.where(status_flag: 0)
    #friendship_requests.map { |request| request.active_user }
  end
end
