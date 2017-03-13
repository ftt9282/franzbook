class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
  	@user = current_user
  	@all_friends = current_user.all_friends
  	@pending_friendships = current_user.pending_friends
  end

  def create
  	@user = User.find(params[:friend_id])
  	current_user.send_friend_request(@user)
  	redirect_to current_user
  end

  def update
  	@friendship = Friendship.find(params[:friendship_id])
  	@friendship.accept_friend_request
  	redirect_to current_user
  end
end