require 'spec_helper'

describe User do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }

  it { should have_many(:boards).dependent(:destroy) }
  it { should have_many(:lists).dependent(:destroy) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:activities).dependent(:destroy) }
  it { should have_many(:pictures).dependent(:destroy) }
  it { should have_many(:payments) }

  describe "uniqueness of email" do
    it "should not create a user with the same email as another user" do
      bob = User.create(first_name: "Bob", last_name: "Smith", email: "hello@world.com", password: "password")
      steve = User.new(first_name: "Steve", last_name: "Jones", email: "hello@world.com", password: "password")
      expect(steve).not_to be_valid
    end

    it "should create a user if the email is unique" do
      bob = User.create(first_name: "Bob", last_name: "Smith", email: "hello@world.com", password: "password")
      steve = User.new(first_name: "Steve", last_name: "Jones", email: "steve@world.com", password: "password")
      expect(steve).to be_valid
    end
  end

  describe "#generate_token" do
    it "generates a token when a new user is created" do
      user = Fabricate(:user)
      expect(user.token).to be_present
    end
  end

  describe "#activate!" do
    it "activates a user" do
      user = Fabricate(:user, active: false)
      user.activate!
      expect(user.active).to eq(true)
    end
  end

  describe "#deactivate!" do
    it "deactivates a user" do
      user = Fabricate(:user)
      user.deactivate!
      expect(user.active).to eq(false)
    end
  end

  describe "#seed_user" do
    it "should seed new users with stock data" do
      user = Fabricate(:user)
      expect(user.boards.size).not_to eq(0)
      expect(user.lists.size).not_to eq(0)
      expect(user.cards.size).not_to eq(0)
      expect(user.activities.size).not_to eq(0)
    end
  end
end
