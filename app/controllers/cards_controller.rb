class CardsController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user
  before_action :set_picture, only: [:show]

  def index
    respond_with Card.where(user_id: current_user.id)
  end

  def show
    @user = User.find(session[:user_id])
    if !@user.cards.where(slug: params[:id])[0]
      redirect_to root_path
    else
      render layout: "logged_in_user"
    end
  end

  def create
    respond_with Card.create(card_params.merge({ user_id: current_user.id }))
  end

  def update
    if Card.find(params[:id]).user == current_user
      respond_with Card.update(params[:id], card_params)
    end
  end

  def destroy
    if Card.find(params[:id]).user == current_user
      respond_with Card.destroy(params[:id])
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :description, { :labels => [] }, { :due_date => [:date, :time] }, :due_date_highlighted, :archived, :position, :list_id)
  end
end
