require 'spec_helper'

feature "user signs in" do
  let(:alice) { Fabricate(:user) }

  scenario "with valid email and password" do
    visit welcome_path
    find(".welcome_link_blue").click
    page.should have_content "Log in to TrelloClone"

    login(alice)
    page.should have_content "#{alice.first_name} #{alice.last_name}"
  end

  scenario "with invalid email and password" do
    visit login_path
    fill_in "Email", with: alice.email
    fill_in "Password", with: alice.password + "asjhak"
    find("input[type='submit']").click
    page.should have_content "Invalid email/password"
  end

  scenario "and then logs out" do
    login(alice)
    page.should have_content "#{alice.first_name} #{alice.last_name}"
    logout
    page.should have_content "OMG! Check out my Trello clone!"
  end
end

feature "admin signs in" do
  scenario "with valid email and password" do
    alice = Fabricate(:admin)
    visit login_path
    login(alice)
    page.should have_content "Admin Home"
  end
end
