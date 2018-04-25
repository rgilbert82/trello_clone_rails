class ForgotPasswordsController < ApplicationController
  before_action :require_no_user, only: [:new, :create, :confirm]

  def new
  end

  def create
    user = User.where(email: params[:email]).first

    if user
      ApplicationMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank" : "There is no user with that email address"
      redirect_to forgot_password_path
    end
  end

  def confirm
  end
end
