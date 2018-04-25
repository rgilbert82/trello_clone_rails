require 'spec_helper'

feature "user edits account info" do
  let(:alice) { Fabricate(:user, email: "alice@example.com") }
  before { login(alice) }

  scenario "with valid input for non email update" do
    visit edit_account_path(id: alice.id)
    page.should have_content "Edit User Info"

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Password", with: "new_password"
    find("input[type='submit']").click
    page.should have_content "Your account was updated successfully"
  end

  scenario "with valid input for email update" do
    customer = double(:customer, successful?: true, customer_token: "abcdefg")
    StripeWrapper::Customer.should_receive(:update_email).and_return(customer)

    visit edit_account_path(id: alice.id)
    page.should have_content "Edit User Info"

    fill_in "Email", with: "new_email@alice.com"
    fill_in "Password", with: "new_password"
    find("input[type='submit']").click
    page.should have_content "Your account was updated successfully"
  end

  scenario "with invalid input" do
    visit edit_account_path(id: alice.id)
    find("input[type='submit']").click
    page.should have_content "Password can't be blank"
  end

  scenario "for users not logged in" do
    visit logout_path
    page.should have_content "OMG! Check out my Trello clone!"

    visit edit_account_path(id: alice.id)
    page.should have_content "OMG! Check out my Trello clone!"
  end
end
