require 'spec_helper'

describe BoardsController do
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

    it "sets @user for authenticated users" do
      session[:user_id] = alice.id
      get :show, id: board1.slug
      expect(assigns(:user)).to eq(alice)
    end

    it "has a status of 200 for logged in users" do
      session[:user_id] = alice.id
      get :show, id: board1.slug
      expect(response.code).to eq("200")
    end

    it "redirects to the root page for an invalid board id" do
      session[:user_id] = alice.id
      get :show, id: board1.slug + 'sodfiwo'
      expect(response).to redirect_to root_path
    end

    it "redirects to the welcome page for unauthenticated users" do
      get :show, id: board1.slug
      expect(response).to redirect_to welcome_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }

    it "creates the board" do
      session[:user_id] = alice.id
      post :create, format: :json, board: { title: "New Board!", starred: false }
      expect(Board.last.title).to eq("New Board!")
    end

    it "does not create a board if the title is missing" do
      session[:user_id] = alice.id
      post :create, format: :json, board: { title: "New Board!", starred: false }
      post :create, format: :json, board: { title: "", starred: false }
      expect(Board.last.title).to eq("New Board!")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, format: :json, board: { title: "New Board!", starred: false }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }

    it "updates the board" do
      session[:user_id] = alice.id
      post :update, id: board1.id, format: :json, board: { title: "New Title!" }
      expect(board1.reload.title).to eq("New Title!")
    end

    it "does not update the board if the user did not create the board" do
      session[:user_id] = bob.id
      post :update, id: board1.id, format: :json, board: { title: "New Title!" }
      expect(board1.reload.title).not_to eq("New Title!")
    end

    it "does not update a board if the title is missing" do
      session[:user_id] = alice.id
      post :update, id: board1.id, format: :json, board: { title: "" }
      expect(board1.reload.title).not_to eq("")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :update, id: board1.id, format: :json, board: { title: "New Title!" }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }

    it "deletes the board" do
      session[:user_id] = alice.id
      delete :destroy, id: board1.id, format: :json
      expect(Board.all).not_to include(board1)
    end

    it "does not delete the card if the user did not create the card" do
      session[:user_id] = bob.id
      delete :destroy, id: board1.id, format: :json
      expect(Board.all).to include(board1)
    end

    it "redirects to the welcome page for unauthenticated users" do
      delete :destroy, id: board1.id, format: :json
      expect(response).to redirect_to welcome_path
    end
  end
end
