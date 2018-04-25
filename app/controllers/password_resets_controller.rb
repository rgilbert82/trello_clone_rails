class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first

    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first

    if user
      user.password = params[:password]
      user.generate_token
      if user.save
        flash[:success] = "Your password has been reset"
        redirect_to login_path
      else
        flash[:error] = user.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    else
      redirect_to expired_token_path
    end
  end

  def expired_token
  end
end
