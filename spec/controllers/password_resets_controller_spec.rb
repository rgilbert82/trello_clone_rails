require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    let(:alice) { Fabricate(:user) }

    it "renders the show template if the token is valid" do
      alice.update_column(:token, "12345")
      get :show, id: "12345"
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice.update_column(:token, "12345")
      get :show, id: "12345"
      expect(assigns(:token)).to eq("12345")
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: "12345"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user, password: "old_password") }
    before { request.env["HTTP_REFERER"] = "/welcome" }

    context "with valid token" do
      it "redirects to the sign in page" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(response).to redirect_to login_path
      end

      it "updates the user's password" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end

      it "sets the flash success message" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(flash[:success]).to be_present
      end

      it "regenerates the user's token" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(alice.reload.token).not_to eq("12345")
      end

      it "redirects back to the welcome page if new password is invalid" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: ""
        expect(response).to redirect_to welcome_path
      end

      it "sets an error message if the new password is invalid" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: ""
        expect(flash[:error]).to be_present
      end
    end

    context "with invalid token" do
      it "redirects to the expired_token_path" do
        post :create, token: "12345", password: "some_password"
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
