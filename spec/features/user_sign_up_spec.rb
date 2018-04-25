require 'spec_helper'

feature "user signs up", { js: true, vcr: true } do
  let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }

  scenario "with valid info" do
    StripeWrapper::Customer.should_receive(:create).and_return(customer)
    visit register_path

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Email", with: "jdoe@example.com"
    fill_in "Password", with: "password"
    fill_in_valid_card

    find("input[type='submit']").click
    expect(page).to have_content "John Doe"
  end

  scenario "with invalid info" do
    visit register_path

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Email", with: "jdoe@example.com"
    fill_in_valid_card

    find("input[type='submit']").click
    expect(page).to have_content "Password can't be blank"
  end
end
