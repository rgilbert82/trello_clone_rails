require 'spec_helper'

describe PicturesController do
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
    let(:bob) { Fabricate(:user, active: false) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) {Fabricate(:list, user_id: alice.id, board_id: board1.id, position: 1)}
    let(:card1) { Fabricate(:card, user_id: alice.id, list_id: list1.id, position: 1) }
    let(:image_file) { fixture_file_upload('files/taco.png', 'image/png') }
    before { request.env["HTTP_REFERER"] = "/" }

    it "seeds one picture with creation of the user" do
      expect(alice.pictures.count).to eq(1)
    end

    it "creates the picture for logged in users" do
      session[:user_id] = alice.id
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(alice.pictures.count).to eq(2)
    end

    it "redirects back to the root page" do
      session[:user_id] = alice.id
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(response).to redirect_to root_path
    end

    it "sets an error message if there is a problem with the upload" do
      session[:user_id] = alice.id
      post :create, picture: { image: "", card_id: card1.id }
      expect(session[:error_msg]).to be_present
    end

    it "redirects back to the root page if there is a problem with the upload" do
      session[:user_id] = alice.id
      post :create, picture: { image: "", card_id: card1.id }
      expect(response).to redirect_to root_path
    end

    it "does not create an image for unauthenticated users" do
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(alice.pictures.count).to eq(1)
    end

    it "redirects to the welcome page for unauthenticated users" do
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(response).to redirect_to welcome_path
    end

    it "does not create an image for inactive users" do
      session[:user_id] = bob.id
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(bob.pictures.count).to eq(1)
    end

    it "redirects to the account page for inactive users" do
      session[:user_id] = bob.id
      post :create, picture: { image: image_file, card_id: card1.id }
      expect(response).to redirect_to account_path
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:board1) { Fabricate(:board, user_id: alice.id) }
    let(:list1) { Fabricate(:list, position: 1, user_id: alice.id, board_id: board1.id) }
    let(:card1) { Fabricate(:card, position: 1, user_id: alice.id, list_id: list1.id) }
    let(:picture1) { alice.pictures.first }

    it "deletes the image for logged in users" do
      session[:user_id] = alice.id
      delete :destroy, id: picture1.id, format: :json
      expect(alice.reload.pictures.count).to eq(0)
    end

    it "does not delete the image for unauthenticated users" do
      delete :destroy, id: picture1.id, format: :json
      expect(alice.reload.pictures.count).to eq(1)
    end

    it "redirects to the welcome page for unauthenticated users" do
      delete :destroy, id: picture1.id, format: :json
      expect(response).to redirect_to welcome_path
    end

    it "does not delete the image for users who don't own the image" do
      session[:user_id] = bob.id
      delete :destroy, id: picture1.id, format: :json
      expect(alice.reload.pictures.count).to eq(1)
    end
  end
end
