# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: "コメントが作成されました"
    else
      @comments = @commentable.comments
      render_commentable_show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
