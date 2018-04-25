class UserSubscription
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def unsubscribe
    user_unsubscribe = StripeWrapper::Customer.unsubscribe(
      :customer_token => @user.customer_token
    )

    if user_unsubscribe.successful?
      @user.deactivate!
      @status = :success
      self
    else
      @error_message = user_unsubscribe.error_message
      @status = :failed
      self
    end
  end

  def subscribe
    subscription = StripeWrapper::Customer.subscribe(
      :customer_token => @user.customer_token
    )

    if subscription.successful?
      @user.activate!
      @status = :success
      self
    else
      @error_message = subscription.error_message
      @status = :failed
      self
    end
  end

  def successful?
    @status == :success
  end
end
