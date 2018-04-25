class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :current_user_initials, :current_user_username, :current_user_is_admin?, :logged_in?

  def current_user
    if session[:user_id] && User.exists?(session[:user_id])
      @current_user ||= User.find(session[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user_is_admin?
    logged_in? && current_user.admin?
  end

  def require_user
    redirect_to welcome_path unless current_user
  end

  def require_active_user
    unless current_user.active?
      flash[:error] = "Your account has been deactivated. You must update your payment information to access all the TrelloClone features."
      redirect_to account_path
    end
  end

  def require_non_active_user
    if current_user.active?
      redirect_to account_path
    end
  end

  def require_no_user
    redirect_to root_path if current_user
  end

  def require_no_admin
    redirect_to admin_path if current_user_is_admin?
  end

  def current_user_initials
    current_user.initials
  end

  def current_user_username
    current_user.full_name
  end

  def set_picture
    @picture = Picture.new
  end
end
