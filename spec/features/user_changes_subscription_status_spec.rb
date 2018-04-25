require 'spec_helper'

feature "user changes scubscription status:" do
  scenario "deactivates successfully" do
    customer = double(:customer, successful?: true)
    StripeWrapper::Customer.should_receive(:unsubscribe).and_return(customer)

    alice = Fabricate(:user)
    login(alice)
    visit edit_account_path
    click_link "Deactivate Account"

    expect(page).to have_content "You successfully deactivated your account."
  end

  scenario "subscribes successfully" do
    customer1 = double(:customer, response: {})
    customer2 = double(:customer, successful?: true)
    StripeWrapper::Customer.should_receive(:get_card_info).and_return(customer1)
    StripeWrapper::Customer.should_receive(:subscribe).and_return(customer2)

    alice = Fabricate(:user, customer_token: "asjhaskdjh", active: false)
    login(alice)
    visit subscribe_path
    click_button "Subscribe"

    expect(page).to have_content "You have subscribed to TrelloClone!"
  end

  scenario "deletes account successfully" do
    customer = double(:customer, successful?: true)
    StripeWrapper::Customer.should_receive(:delete).and_return(customer)

    alice = Fabricate(:user)
    login(alice)
    visit edit_account_path
    click_link "Delete Account"

    expect(page).to have_content "You have successfully deleted your account. Sign up again!"
  end
end
