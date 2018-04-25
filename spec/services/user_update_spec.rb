require 'spec_helper'

describe UserUpdate do
  describe "#update" do
    context "for valid update" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: true) }

      it "updates the email" do
        StripeWrapper::Customer.should_receive(:update_email).and_return(customer)
        UserUpdate.new(alice).update({ email: "new_email@email.com"})
        expect(alice.reload.email).to eq("new_email@email.com")
      end

      it "doesn't update the email if the email is not changed" do
        StripeWrapper::Customer.should_not_receive(:update_email)
        UserUpdate.new(alice).update({ email: "alice@example.com"})
        expect(alice.reload.email).to eq("alice@example.com")
      end
    end

    context "for invalid update" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: false, error_message: "Error!") }

      it "does not update the email for invalid user update" do
        StripeWrapper::Customer.should_not_receive(:update_email)
        UserUpdate.new(alice).update({ email: ""})
        expect(alice.reload.email).to eq("alice@example.com")
      end
    end
  end

  describe "#update_payment" do
    context "for user with card on file" do
      let(:alice) { Fabricate(:user, email: "alice@example.com", customer_token: "askfhk") }
      let(:customer) { double(:customer, successful?: true) }
      let(:customer2) { double(:customer, successful?: false, error_message: "Error!") }

      it "updates the payment" do
        StripeWrapper::Customer.should_receive(:update_credit_card).and_return(customer)
        update = UserUpdate.new(alice).update_payment("some_stripe_token")
        expect(update.successful?).to eq(true)
      end

      it "doesn't update the payment if there is a stripe error" do
        StripeWrapper::Customer.should_receive(:update_credit_card).and_return(customer2)
        update = UserUpdate.new(alice).update_payment("some_stripe_token")
        expect(update.successful?).to eq(false)
        expect(update.error_message).to eq("Error!")
      end
    end

    context "for user with no card on file" do
      let(:alice) { Fabricate(:user, email: "alice@example.com", active: false) }
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdef") }
      let(:customer2) { double(:customer, successful?: false, error_message: "Error!") }

      it "updates the payment" do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        update = UserUpdate.new(alice).update_payment("some_stripe_token")
        expect(update.successful?).to eq(true)
        expect(alice.reload.customer_token).to eq("abcdef")
        expect(alice.reload.active).to eq(true)
      end

      it "doesn't update the payment if there is a stripe error" do
        StripeWrapper::Customer.should_receive(:create).and_return(customer2)
        update = UserUpdate.new(alice).update_payment("some_stripe_token")
        expect(update.successful?).to eq(false)
        expect(update.error_message).to eq("Error!")
      end
    end
  end
end
