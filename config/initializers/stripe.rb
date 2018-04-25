Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.event_retriever = lambda do |params|
  if params[:livemode]
    ::Stripe::Event.retrieve(params[:id])
  elsif Rails.env.development? || Rails.env.production?
    # This will return an event as is from the request (security concern in production)
    ::Stripe::Event.construct_from(params.deep_symbolize_keys)
  else
    nil
  end
end

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.where(customer_token: event.data.object.customer).first
    if user
      Payment.create(user: user,
                     amount: event.data.object.amount,
                     reference_id: event.data.object.id )
    end
  end

  events.subscribe 'charge.failed' do |event|
    user = User.where(customer_token: event.data.object.customer).first
    user.deactivate! if user
  end
end
