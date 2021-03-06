class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    redirect_to current_user
  end

  def update

  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
