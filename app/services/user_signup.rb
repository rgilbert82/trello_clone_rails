class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        :user => @user,
        :card => stripe_token
      )

      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = @user.errors.full_messages.to_sentence
      self
    end
  end

  def successful?
    @status == :success
  end
end
