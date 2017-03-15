class PostsController < ApplicationController
  def create
  	@post = current_user.posts.build(post_params)
  	if @post.save
  	  #success message
  	else
      #fail message
  	end
  	redirect_to current_user
  end

  def update
  end

  private

  def post_params
  	params.require(:post).permit(:content)
  end
end
