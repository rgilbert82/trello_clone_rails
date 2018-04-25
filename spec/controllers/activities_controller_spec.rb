require 'spec_helper'

describe ActivitiesController do
  describe "GET index" do
    let(:alice) { Fabricate(:user) }

    it "has a status of 200 for logged in users" do
      session[:user_id] = alice.id
      get :index, format: :json
      expect(response.code).to eq("200")
    end

    it "responds with JSON content for logged in users" do
      session[:user_id] = alice.id
      get :index, format: :json
      response.header['Content-Type'].should include 'application/json'
    end

    it "redirects to the welcome page for unauthenticated users" do
      get :index, format: :json
      expect(response).to redirect_to welcome_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }
    let(:card1) { Fabricate(:card, position: 1, user_id: alice.id, list_id: list1.id) }

    it "creates the activity" do
      session[:user_id] = alice.id
      post :create, format: :json, activity: { comment: false, description: "New Activity!", card_id: card1.id }
      expect(Activity.last.description).to eq("New Activity!")
    end

    it "does not create a activity if the description is missing" do
      session[:user_id] = alice.id
      post :create, format: :json, activity: { comment: false, description: "New Activity!", card_id: card1.id }
      post :create, format: :json, activity: { comment: false, description: "", card_id: card1.id }
      expect(Activity.last.description).to eq("New Activity!")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, format: :json, activity: { comment: false, description: "New Activity!", card_id: card1.id }
      expect(response).to redirect_to welcome_path
    end
  end
end
