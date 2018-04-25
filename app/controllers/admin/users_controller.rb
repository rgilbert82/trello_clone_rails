class Admin::UsersController < Admin::AdminsController
  def index
    @admins = User.where(admin: true)
    @active_users = User.where(admin: nil, active: true)
    @inactive_users = User.where(admin: nil, active: false)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_back(fallback_location: admin_users_path)
  end
end
