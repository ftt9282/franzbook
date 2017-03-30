class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
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
    active_friend_ids =  "SELECT active_user_id FROM friendships
                          WHERE status_flag = 1
                          AND (passive_user_id = :user_id OR active_user_id = :user_id)"

    passive_friend_ids =  "SELECT passive_user_id FROM friendships
                          WHERE status_flag = 1
                          AND (passive_user_id = :user_id OR active_user_id = :user_id)"
                          
    Post.where("user_id IN (#{active_friend_ids})
                OR user_id IN (#{passive_friend_ids})
                OR user_id = :user_id", user_id: id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
