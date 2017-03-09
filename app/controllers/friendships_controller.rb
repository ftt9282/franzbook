class FriendshipsController < ApplicationController
  def create
  	@user = User.find(params[:friend_id])
  	current_user.send_friend_request(@user)
  	redirect_to @user
  end
end
