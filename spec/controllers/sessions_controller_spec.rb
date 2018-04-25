require 'spec_helper'

describe SessionsController do
  describe "GET welcome" do
    it "renders the home template for unauthenticated users" do
      get :welcome
      expect(response).to render_template :welcome
    end

    it "redirects to the root page for authenticated users" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :welcome
      expect(response).to redirect_to root_path
    end
  end

  describe "GET new" do
    it "renders the home template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the root page for authenticated users" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "redirects to the root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid credentials" do
      before do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'slfkaakj'
      end

      it "does not put the signed in user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to login_path
      end

      it "sets the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :destroy
    end

    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the welcome path" do
      expect(response).to redirect_to welcome_path
    end
  end
end
