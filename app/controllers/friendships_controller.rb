class FriendshipsController < ApplicationController
  def index
  	@user = current_user
  	#@friendships = current_user.all_friendships #create method later
  	@pending_friendships = current_user.pending_friends
  end

  def create
  	@user = User.find(params[:friend_id])
  	current_user.send_friend_request(@user)
  	redirect_to current_user
  end
end
