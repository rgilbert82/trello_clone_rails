class UserDelete
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def delete
    user_delete = StripeWrapper::Customer.delete(
      :customer_token => @user.customer_token
    )

    if user_delete.successful?
      @user.destroy
      @status = :success
      self
    else
      @error_message = user_delete.error_message
      @status = :failed
      self
    end
  end

  def successful?
    @status == :success
  end
end
