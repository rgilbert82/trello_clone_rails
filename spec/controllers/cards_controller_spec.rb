require 'spec_helper'

describe CardsController do
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

  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }
    let(:card1) { Fabricate(:card, position: 1, user_id: alice.id, list_id: list1.id) }

    it "sets @user for authenticated users" do
      session[:user_id] = alice.id
      get :show, id: card1.slug
      expect(assigns(:user)).to eq(alice)
    end

    it "has a status of 200 for logged in users" do
      session[:user_id] = alice.id
      get :show, id: card1.slug
      expect(response.code).to eq("200")
    end

    it "redirects to the root page for an invalid card id" do
      session[:user_id] = alice.id
      get :show, id: card1.slug + 'sodfiwo'
      expect(response).to redirect_to root_path
    end

    it "redirects to the welcome page for unauthenticated users" do
      get :show, id: card1.slug
      expect(response).to redirect_to welcome_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }

    it "creates the card" do
      session[:user_id] = alice.id
      post :create, format: :json, card: { title: "New Card!", description: "Hello", archived: false, position: 1, list_id: list1.id }
      expect(Card.last.title).to eq("New Card!")
    end

    it "does not create a card if the title is missing" do
      session[:user_id] = alice.id
      post :create, format: :json, card: { title: "New Card!", description: "Hello", archived: false, position: 1, list_id: list1.id }
      post :create, format: :json, card: { title: "", description: "Hello", archived: false, position: 1, list_id: list1.id }
      expect(Card.last.title).to eq("New Card!")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, format: :json, card: { title: "New Card!", description: "Hello", archived: false, position: 1, list_id: list1.id }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }
    let(:card1) { Fabricate(:card, position: 1, user_id: alice.id, list_id: list1.id) }

    it "updates the card" do
      session[:user_id] = alice.id
      post :update, id: card1.id, format: :json, card: { title: "New Title!" }
      expect(card1.reload.title).to eq("New Title!")
    end

    it "does not update the card if the user did not create the card" do
      session[:user_id] = bob.id
      post :update, id: card1.id, format: :json, card: { title: "New Title!" }
      expect(card1.reload.title).not_to eq("New Title!")
    end

    it "does not update a card if the title is missing" do
      session[:user_id] = alice.id
      post :update, id: card1.id, format: :json, card: { title: "" }
      expect(card1.reload.title).not_to eq("")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :update, id: card1.id, format: :json, card: { title: "New Title!" }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }
    let(:card1) { Fabricate(:card, position: 1, user_id: alice.id, list_id: list1.id) }

    it "deletes the card" do
      session[:user_id] = alice.id
      delete :destroy, id: card1.id, format: :json
      expect(Card.all).not_to include(card1)
    end

    it "does not delete the card if the user did not create the card" do
      session[:user_id] = bob.id
      delete :destroy, id: card1.id, format: :json
      expect(Card.all).to include(card1)
    end

    it "redirects to the welcome page for unauthenticated users" do
      delete :destroy, id: card1.id, format: :json
      expect(response).to redirect_to welcome_path
    end
  end
end
