require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "created the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token")
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token")
        expect(User.first.customer_token).to eq("abcdefg")
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined?")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("123123")
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not create the user" do
        UserSignup.new(User.new(email: "ryan@example.com")).sign_up("123123")
        expect(User.count).to eq(0)
      end

      it "does not charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(User.new(email: "ryan@example.com")).sign_up("123123")
      end
    end
  end
end
