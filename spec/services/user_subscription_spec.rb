require 'spec_helper'

describe UserSubscription do
  describe "#subscribe" do
    context "for valid subscribe" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: true) }

      it "subscribes the user" do
        StripeWrapper::Customer.should_receive(:subscribe).and_return(customer)
        subscription = UserSubscription.new(alice).subscribe
        expect(subscription.successful?).to be_truthy
      end
    end

    context "for invalid subscribe" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: false, error_message: "Error!") }

      it "does not subscribe the user" do
        StripeWrapper::Customer.should_receive(:subscribe).and_return(customer)
        subscription = UserSubscription.new(alice).subscribe
        expect(subscription.successful?).to be_falsy
      end
    end
  end

  describe "#unsubscribe" do
    context "for valid unsubscribe" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: true) }

      it "subscribes the user" do
        StripeWrapper::Customer.should_receive(:unsubscribe).and_return(customer)
        subscription = UserSubscription.new(alice).unsubscribe
        expect(subscription.successful?).to be_truthy
      end
    end

    context "for invalid unsubscribe" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: false, error_message: "Error!") }

      it "does not subscribe the user" do
        StripeWrapper::Customer.should_receive(:unsubscribe).and_return(customer)
        subscription = UserSubscription.new(alice).unsubscribe
        expect(subscription.successful?).to be_falsy
      end
    end
  end
end
