class PicturesController < ApplicationController
  respond_to :json
  before_action :require_user
  before_action :require_active_user

  def index
    pictures = Picture.where(user_id: current_user.id).map do |b|
      attrs = {
        url_full: b.image_url.to_s,
        url_thumb: b.image_url(:thumb).to_s,
        date_time: b.get_formatted_datetime
      }
      b.attributes.merge(attrs)
    end

    respond_with pictures
  end

  def create
    picture = Picture.new(picture_params.merge({ user_id: current_user.id }))

    unless picture.save
      session[:error_msg] = picture.errors.full_messages.to_sentence
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    if Picture.find(params[:id]).user == current_user
      respond_with Picture.destroy(params[:id])
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:image, :card_id)
  end
end
