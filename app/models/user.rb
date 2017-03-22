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
  has_many :posts
  has_many :comments

  def full_name
    self.first_name + " " + self.last_name
  end
  
  # Sends a friend request to another user
  def send_friend_request(other_user)
    friend_requests << other_user
  end

  # Returns an array of users who offered the current user a friend request
  def pending_friends
  	self.passive_relationships.where(status_flag: 0)
  end

  def all_friends
    friendships = passive_relationships.where(status_flag: 1) + active_relationships.where(status_flag: 1)
    friendships.map { |f| f.active_user == self ? f.passive_user : f.active_user }
  end

  def franz_feed
    byebug
    active_user_ids =   "SELECT active_user_id FROM friendships
                         WHERE passive_user_id = :user_id
                         AND status_flag = 1"
    passive_user_ids =  "SELECT passive_user_id FROM friendships
                         WHERE active_user_id = :user_id
                         AND status_flag = 1"
    thing = Post.where("user_id ANY ((#{active_user_ids}), (#{passive_user_ids}))
                OR user_id = :user_id", user_id: id)
  end
end
