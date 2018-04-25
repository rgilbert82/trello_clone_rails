require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 6,
        :exp_year => 2020,
        :cvc => 314
      }
    ).id
  end

  let(:valid_token2) do
    Stripe::Token.create(
      :card => {
        :number => "4012888888881881",
        :exp_month => 6,
        :exp_year => 2020,
        :cvc => 314
      }
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 6,
        :exp_year => 2020,
        :cvc => 314
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do  # User '.' for class methods, '#' for instance methods
      it "makes a successful charge", :vcr do  # Don't forget to setup VCR in spec_helper
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: valid_token,
          description: "A valid charge",
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: declined_card_token,
          description: "An invalid charge",
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: declined_card_token,
          description: "An invalid charge",
        )

        expect(response.error_message).to be_present
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        alice = Fabricate(:user)

        response = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        )

        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)

        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it "returns an error message for a declined card", :vcr do
        alice = Fabricate(:user)

        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )

        expect(response.error_message).to be_present
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)

        response = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        )

        expect(response.customer_token).to be_present
      end
    end

    describe ".update_email" do
      it "updates a customer email", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.update_email(
          customer_token: customer_token,
          email: "new_email@example.com"
        )
        expect(response).to be_successful
      end

      it "doesn't update email if the customer_token is incorrect", :vcr do
        response = StripeWrapper::Customer.update_email(
          customer_token: "bad_customer_token",
          email: "new_email@example.com"
        )
        expect(response).not_to be_successful
      end
    end

    describe ".update_credit_card" do
      it "updates a credit card", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.update_credit_card(
          customer_token: customer_token,
          card: valid_token2
        )

        expect(response).to be_successful
      end

      it "doesn't update a credit card for an invalid card", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.update_credit_card(
          customer_token: customer_token,
          card: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it "doesn't update a card for an invalid customer_token", :vcr do
        response = StripeWrapper::Customer.update_credit_card(
          customer_token: "bad_customer_token",
          card: valid_token
        )

        expect(response).not_to be_successful
      end
    end

    describe ".unsubscribe" do
      it "unsubscribes a customer", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.unsubscribe(
          customer_token: customer_token
        )

        expect(response).to be_successful
      end

      it "doesn't unsubscribe a customer with an invalid token", :vcr do
        response = StripeWrapper::Customer.unsubscribe(
          customer_token: "bad_customer_token"
        )

        expect(response).not_to be_successful
      end
    end

    describe ".subscribe" do
      it "subscribes a customer", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        StripeWrapper::Customer.unsubscribe(
          customer_token: customer_token
        )

        response = StripeWrapper::Customer.subscribe(
          customer_token: customer_token
        )

        expect(response).to be_successful
      end

      it "does not subscribe a customer with an invalid token", :vcr do
        response = StripeWrapper::Customer.subscribe(
          customer_token: "bad_customer_token"
        )

        expect(response).not_to be_successful
      end
    end

    describe ".delete" do
      it "deletes a customer", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.delete(
          customer_token: customer_token
        )

        expect(response).to be_successful
      end

      it "does not delete a customer with an invalid token", :vcr do
        response = StripeWrapper::Customer.delete(
          customer_token: "bad_customer_token"
        )

        expect(response).not_to be_successful
      end
    end

    describe ".get_card_info" do
      it "gets the card info", :vcr do
        alice = Fabricate(:user)

        customer_token = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        ).customer_token

        response = StripeWrapper::Customer.get_card_info(
          customer_token: customer_token
        )

        expect(response).to be_successful
      end

      it "doesn't get the card info for an in valid customer token", :vcr do
        response = StripeWrapper::Customer.get_card_info(
          customer_token: "bad_customer_token"
        )

        expect(response).not_to be_successful
      end
    end
  end
end
