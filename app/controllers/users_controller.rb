class UsersController < ApplicationController
  respond_to :json
  before_action :require_user, only: [:home, :index, :show, :edit, :update, :edit_payment, :update_payment, :account, :subscribe, :activate, :deactivate, :destroy]
  before_action :require_active_user, only: [:home, :edit_payment, :update_payment, :deactivate]
  before_action :require_non_active_user, only: [:subscribe, :activate]
  before_action :require_no_user, only: [:new, :create]
  before_action :require_no_admin, only: [:edit_payment, :update_payment, :subscribe, :activate, :deactivate]
  before_action :set_user, only: [:home, :account, :index, :show, :edit, :update, :edit_payment, :update_payment, :subscribe, :activate, :deactivate, :destroy]
  before_action :set_picture, only: [:home]

  def home
    render layout: "logged_in_user"
  end

  def index
    respond_with User.find(@user.id)
  end

  def show
    respond_with User.find(@user.id)
  end

  def account
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken])

    if result.successful?
      session[:user_id] = @user.id
      session[:success_msg] = "Thank you for registering with TrelloClone!"
      redirect_to root_path
    else
      flash[:error] = result.error_message
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
  end

  def update
    result = UserUpdate.new(@user).update(user_params)

    if result.successful?
      flash[:success] = "Your account was updated successfully."
      redirect_to account_path
    else
      flash[:error] = result.error_message
      redirect_back(fallback_location: root_path)
    end
  end

  def edit_payment
    @card_info = get_card_info(@user)
  end

  def update_payment
    payment_update = UserUpdate.new(@user).update_payment(params[:stripeToken])

    if payment_update.successful?
      flash[:success] = "You successfully updated your credit card."
      redirect_to account_path
    else
      flash[:error] = payment_update.error_message
      redirect_back(fallback_location: account_path)
    end
  end

  def subscribe
    @card_info = get_card_info(@user)
  end

  def activate
    if params[:stripeToken]
      payment_update = UserUpdate.new(@user).update_payment(params[:stripeToken])

      unless payment_update.successful?
        flash[:error] = payment_update.error_message
        redirect_back(fallback_location: account_path)
        return
      end
    end

    subscription = UserSubscription.new(@user).subscribe

    if subscription.successful?
      flash[:success] = "You have subscribed to TrelloClone!"
      redirect_to account_path
    else
      flash[:error] = subscription.error_message
      redirect_back(fallback_location: account_path)
    end
  end

  def deactivate
    end_subscription = UserSubscription.new(@user).unsubscribe

    if end_subscription.successful?
      flash[:success] = "You successfully deactivated your account. You must re-subscribe if you want to access your Trello boards again."
      redirect_to account_path
    else
      flash[:error] = end_subscription.error_message
      redirect_back(fallback_location: account_path)
    end
  end

  def destroy
    delete_account = UserDelete.new(@user).delete

    if delete_account.successful?
      session[:user_id] = nil
      flash[:success] = "You have successfully deleted your account. Sign up again!"
      redirect_to register_path
    else
      flash[:error] = delete_account.error_message
      redirect_back(fallback_location: account_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def set_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def get_card_info(user)
    return false unless user.customer_token

    card_info = StripeWrapper::Customer.get_card_info(
      :customer_token => user.customer_token
    )

    card_info.response
  end
end
