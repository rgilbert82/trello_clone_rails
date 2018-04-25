class ListsController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user

  def index
    respond_with List.where(user_id: current_user.id)
  end

  def create
    respond_with List.create(list_params.merge({ user_id: current_user.id }))
  end

  def update
    if List.find(params[:id]).user == current_user
      respond_with List.update(params[:id], list_params)
    end
  end

  def destroy
    if List.find(params[:id]).user == current_user
      respond_with List.destroy(params[:id])
    end
  end

  private

  def list_params
    params.require(:list).permit(:title, :archived, :position, :board_id)
  end
end
