class BoardsController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user
  before_action :set_picture, only: [:show]

  def index
    respond_with Board.where(user_id: current_user.id)
  end

  def show
    @user = User.find(session[:user_id])

    if !@user.boards.where(slug: params[:id])[0]
      redirect_to root_path
    else
      render layout: "logged_in_user"
    end
  end

  def create
    respond_with Board.create(board_params.merge({ user_id: current_user.id }))
  end

  def update
    if Board.find(params[:id]).user == current_user
      respond_with Board.update(params[:id], board_params)
    end
  end

  def destroy
    if Board.find(params[:id]).user == current_user
      respond_with Board.destroy(params[:id])
    end
  end

  private

  def board_params
    params.require(:board).permit(:title, :starred)
  end
end
