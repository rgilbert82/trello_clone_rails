class CommentsController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user

  def index
    respond_with Comment.where(user_id: current_user.id)
  end

  def create
    respond_with Comment.create(comment_params.merge({ user_id: current_user.id }))
  end

  def update
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_name, :user_initials, :date_time, :card_id)
  end
end
