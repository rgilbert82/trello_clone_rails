require 'spec_helper'

feature "user forgets password" do
  let(:alice) { Fabricate(:user) }

  scenario "for existing user" do
    visit login_path
    click_link "Reset it."
    page.should have_content "We'll send you an email to reset your password"

    fill_in "Email", with: alice.email
    find("input[type='submit']").click
    page.should have_content "We sent an email with instructions to reset your password."
  end

  scenario "for non-existant user" do
    visit forgot_password_path
    fill_in "Email", with: alice.email + ".org"
    find("input[type='submit']").click
    page.should have_content "There is no user with that email address"
  end

  scenario "for empty email" do
    visit forgot_password_path
    fill_in "Email", with: ""
    find("input[type='submit']").click
    page.should have_content "Email cannot be blank"
  end
end
