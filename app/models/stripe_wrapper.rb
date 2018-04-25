module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
        )
        new(response: response) # same as Charge.new(response)
      rescue Stripe::CardError => e
        new(error_message: e.message)  # returns an object that has no response
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message, :customer_token

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          email: options[:user].email,
          plan: "base"
        )

        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def self.update_email(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        customer.email = options[:email]
        response = customer.save
        new(response: response)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def self.update_credit_card(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        customer.card = options[:card]
        response = customer.save
        new(response: response)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def self.subscribe(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        response = Stripe::Subscription.create(
          :customer => customer.id,
          :plan => "base"
        )
        new(response: response)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def self.unsubscribe(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        subscription_ids = customer.subscriptions.data.map {|sub| sub.id }
        subscriptions = subscription_ids.map do |si|
          Stripe::Subscription.retrieve(si)
        end
        subscriptions.each { |sub| sub.delete }
        new(response: customer)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def self.delete(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])
        response = customer.delete
        new(response: response)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def self.get_card_info(options={})
      begin
        customer = Stripe::Customer.retrieve(options[:customer_token])

        response = {
          last_4: customer.sources.data[0].last4,
          expires: "#{customer.sources.data[0].exp_month} / #{customer.sources.data[0].exp_year}"
        }

        new(response: response)
      rescue Stripe::StripeError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end
end
