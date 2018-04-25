require 'spec_helper'

describe UserDelete do
  describe "#delete" do
    context "with valid delete" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: true) }

      it "deletes the user" do
        StripeWrapper::Customer.should_receive(:delete).and_return(customer)
        deletion = UserDelete.new(alice).delete
        expect(deletion.successful?).to be_truthy
      end
    end

    context "with invalid delete" do
      let(:alice) { Fabricate(:user, email: "alice@example.com") }
      let(:customer) { double(:customer, successful?: false, error_message: "Error!") }

      it "does not delete the user" do
        StripeWrapper::Customer.should_receive(:delete).and_return(customer)
        deletion = UserDelete.new(alice).delete
        expect(deletion.successful?).to be_falsy
      end
    end
  end
end
