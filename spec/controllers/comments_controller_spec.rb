require 'spec_helper'

describe CommentsController do
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

    it "creates the comment" do
      session[:user_id] = alice.id
      post :create, format: :json, comment: { body: "New Comment!", card_id: card1.id }
      expect(Comment.last.body).to eq("New Comment!")
    end

    it "does not create a comment if the body is missing" do
      session[:user_id] = alice.id
      post :create, format: :json, comment: { body: "New Comment!", card_id: card1.id }
      post :create, format: :json, comment: { body: "", card_id: card1.id }
      expect(Comment.last.body).to eq("New Comment!")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, format: :json, comment: { body: "New Comment!", card_id: card1.id }
      expect(response).to redirect_to welcome_path
    end
  end
end
