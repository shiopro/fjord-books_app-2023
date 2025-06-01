# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @commentable.comments
      redirect_to @commentable, flash: { alert: @comment.errors.full_messages.to_sentence }
    end
  end

  def update
    return redirect_to root_path, alert: '権限がありません' unless @comment.user == current_user

    if @comment.update(comment_params)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      redirect_to @commentable, flash: { alert: @comment.errors.full_messages.to_sentence }
    end
  end

  def destroy
    return redirect_to root_path, alert: '権限がありません' unless @comment.user == current_user

    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
