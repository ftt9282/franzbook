class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
  end

  def show
  	@user = current_user
  	@post = Post.new
  	@franz_feed = current_user.franz_feed
  end
end