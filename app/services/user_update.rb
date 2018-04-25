class UserUpdate
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def update(user_params)
    subscription_needs_to_be_updated = !@user.admin? && @user.email != user_params[:email]
    @user.assign_attributes(user_params)

    if @user.valid?
      if subscription_needs_to_be_updated
        customer_update = StripeWrapper::Customer.update_email(
          :customer_token => @user.customer_token,
          :email => user_params[:email]
        )
      end

      if !subscription_needs_to_be_updated || customer_update.successful?
        @user.save
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer_update.error_message
        self
      end
    else
      @status = :failed
      @error_message = @user.errors.full_messages.to_sentence
      self
    end
  end

  def update_payment(stripe_token)
    if @user.customer_token.present?
      payment_update = StripeWrapper::Customer.update_credit_card(
        :customer_token => @user.customer_token,
        :card => stripe_token
      )
    else
      payment_update = StripeWrapper::Customer.create(
        :user => @user,
        :card => stripe_token
      )
    end

    if payment_update.successful? && @user.customer_token.present?
      @status = :success
      self
    elsif payment_update.successful?
      @user.update_column(:customer_token, payment_update.customer_token)
      @user.update_column(:active, true)
      @status = :success
      self
    else
      @status = :failed
      @error_message = payment_update.error_message
      self
    end
  end

  def successful?
    @status == :success
  end
end
