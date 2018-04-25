require 'spec_helper'

describe ListsController do
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

    it "creates the list" do
      session[:user_id] = alice.id
      post :create, format: :json, list: { title: "New List!", archived: false, position: 1, board_id: board1.id }
      expect(alice.lists.last.title).to eq("New List!")
    end

    it "does not create a board if the title is missing" do
      session[:user_id] = alice.id
      post :create, format: :json, list: { title: "New List!", archived: false, position: 1, board_id: board1.id }
      post :create, format: :json, list: { title: "", archived: false, position: 1, board_id: board1.id }
      expect(alice.lists.last.title).to eq("New List!")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, format: :json, list: { title: "New List!", archived: false, position: 1, board_id: board1.id }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }

    it "updates the list" do
      session[:user_id] = alice.id
      post :update, id: list1.id, format: :json, list: { title: "New Title!" }
      expect(list1.reload.title).to eq("New Title!")
    end

    it "does not update the list if the user did not create the list" do
      session[:user_id] = bob.id
      post :update, id: list1.id, format: :json, list: { title: "New Title!" }
      expect(list1.reload.title).not_to eq("New Title!")
    end

    it "does not update a list if the title is missing" do
      session[:user_id] = alice.id
      post :update, id: list1.id, format: :json, list: { title: "" }
      expect(list1.reload.title).not_to eq("")
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :update, id: list1.id, format: :json, list: { title: "New Title!" }
      expect(response).to redirect_to welcome_path
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }

    it "deletes the list" do
      session[:user_id] = alice.id
      delete :destroy, id: list1.id, format: :json
      expect(List.all).not_to include(list1)
    end

    it "does not delete the list if the user did not create the list" do
      session[:user_id] = bob.id
      delete :destroy, id: list1.id, format: :json
      expect(List.all).to include(list1)
    end

    it "redirects to the welcome page for unauthenticated users" do
      delete :destroy, id: list1.id, format: :json
      expect(response).to redirect_to welcome_path
    end
  end
end
