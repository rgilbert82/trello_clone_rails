require 'spec_helper'

feature "user with no card on file updates credit card" do
  let(:alice) { Fabricate(:user) }

  scenario "with valid card info" do
    customer = double(:customer, successful?: true, customer_token: "askjkjh")
    StripeWrapper::Customer.should_receive(:create).and_return(customer)

    login(alice)
    visit edit_payment_path
    fill_in_valid_card
    find("input[type='submit']").click

    expect(page).to have_content "You successfully updated your credit card."
  end

  scenario "with invalid card info" do
    customer = double(:customer, successful?: false, error_message: "Error!")
    StripeWrapper::Customer.should_receive(:create).and_return(customer)

    login(alice)
    visit edit_payment_path
    fill_in_invalid_card
    find("input[type='submit']").click

    expect(page).to have_content "Error!"
  end
end

feature "user with card on file updates credit card" do
  let(:alice) { Fabricate(:user, customer_token: "asaksjfhk") }

  scenario "with valid card info" do
    customer = double(:customer, successful?: true)
    card_info = double(:customer, successful?: true, response: {})
    StripeWrapper::Customer.should_receive(:get_card_info).and_return(card_info)
    StripeWrapper::Customer.should_receive(:update_credit_card).and_return(customer)

    login(alice)
    visit edit_payment_path
    fill_in_valid_card
    find("input[type='submit']").click

    expect(page).to have_content "You successfully updated your credit card."
  end

  scenario "with invalid card info" do
    customer = double(:customer, successful?: false, error_message: "Error!")
    card_info = double(:customer, successful?: true, response: {})
    StripeWrapper::Customer.should_receive(:get_card_info).and_return(card_info)
    StripeWrapper::Customer.should_receive(:get_card_info).and_return(card_info)
    StripeWrapper::Customer.should_receive(:update_credit_card).and_return(customer)

    login(alice)
    visit edit_payment_path
    fill_in_invalid_card
    find("input[type='submit']").click

    expect(page).to have_content "Error!"
  end
end
