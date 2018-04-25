class ActivitiesController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user

  def index
    respond_with Activity.where(user_id: current_user.id)
  end

  def create
    respond_with Activity.create(activity_params.merge({ user_id: current_user.id }))
  end

  def update
  end

  private

  def activity_params
    params.require(:activity).permit(:comment, :description, :date_time, :card_id, :picture_id, :user_name, :user_initials)
  end
end
