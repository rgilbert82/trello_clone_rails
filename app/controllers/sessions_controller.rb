class SessionsController < ApplicationController
  before_action :require_no_user, only: [:welcome, :new, :create]
  before_action :require_user, only: [:destroy]

  def welcome
  end

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if current_user_is_admin?
        redirect_to admin_path
      else
        session[:success_msg] = "You are logged in!"
        redirect_to root_path
      end
    else
      flash[:error] = "Invalid email/password"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to welcome_path
  end
end
