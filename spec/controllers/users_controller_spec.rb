require 'spec_helper'

describe UsersController do
  describe "GET home" do
    it "sets @user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :home

      expect(assigns(:user)).to eq(alice)
    end

    it "redirects to welcome path if no user is signed in" do
      get :home
      expect(response).to redirect_to welcome_path
    end

    it "redirects to the account path for inactive users" do
      alice = Fabricate(:user, active: false)
      session[:user_id] = alice.id
      get :home
      expect(response).to redirect_to account_path
    end
  end

  describe "GET account" do
    it "sets @user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :account

      expect(assigns(:user)).to eq(alice)
    end

    it "redirects to welcome path if no user is signed in" do
      get :account
      expect(response).to redirect_to welcome_path
    end
  end

  describe "GET show" do
    let(:alice) { Fabricate(:user) }

    it "has a status of 200 for logged in users" do
      session[:user_id] = alice.id
      get :show, id: alice.id, format: :json
      expect(response.code).to eq("200")
    end

    it "responds with JSON data for logged in users" do
      session[:user_id] = alice.id
      get :show, id: alice.id, format: :json
      response.header['Content-Type'].should include 'application/json'
    end

    it "redirects to the welcome page for unauthenticated users" do
      get :show, id: alice.id, format: :json
      expect(response).to redirect_to welcome_path
    end
  end

  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "redirects to root path if a user is already sign in" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    context "with valid input" do
      it "redirects to the root page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { first_name: "Alice", last_name: "Smith", email: "alice@example.com", password: "password" }
        expect(response).to redirect_to root_path
      end

      it "creates a success message" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { first_name: "Alice", last_name: "Smith", email: "alice@example.com", password: "password" }
        expect(session[:success_msg]).to be_present
      end
    end

    context "with invalid input" do
      before do
        request.env["HTTP_REFERER"] = "/register"
        post :create, user: { first_name: "Alice", password: "password" }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "redirect back to the previous page" do
        expect(response).to redirect_to register_path
      end

      it "sets an error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "with non-unique email" do
      before do
        alice = Fabricate(:user, email: "alice@example.com")
        request.env["HTTP_REFERER"] = "/register"
        post :create, user: { first_name: "Alice", last_name: "Smith", email: "alice@example.com",password: "password" }
      end

      it "does not create the user" do
        expect(User.count).to eq(1)
      end

      it "redirect back to the previous page" do
        expect(response).to redirect_to register_path
      end

      it "sets an error message" do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET edit" do
    let(:alice) { Fabricate(:user) }

    it "sets @user if logged in" do
      session[:user_id] = alice.id
      get :edit, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "redirects to login path if not logged in" do
      get :edit, id: alice.id
      expect(response).to redirect_to welcome_path
    end
  end

  describe "PATCH update" do
    context "for authenticated users" do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
        request.env["HTTP_REFERER"] = "/"
      end

      it "redirects to the account page" do
        result = double(:update_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update).and_return(result)
        patch :update, id: alice.id, user: {first_name: "Jane", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(response).to redirect_to account_path
      end

      it "creates a success message for successful updates" do
        result = double(:update_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update).and_return(result)
        patch :update, id: alice.id, user: {first_name: "Jane", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(flash[:success]).to be_present
      end

      it "redirects back to the root page for unsuccessful update" do
        result = double(:update_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update).and_return(result)
        patch :update, id: alice.id, user: {first_name: "", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(response).to redirect_to root_path
      end

      it "creates an error message for unsuccessful updates" do
        result = double(:update_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update).and_return(result)
        patch :update, id: alice.id, user: {first_name: "", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(flash[:error]).to be_present
      end
    end

    context "for unauthenticated users" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      it "redirects to the login path" do
        patch :update, id: alice.id, user: {first_name: "Jane", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(response).to redirect_to welcome_path
      end

      it "doesn't update the user if another user is logged in" do
        session[:user_id] = bob.id
        request.env["HTTP_REFERER"] = "/"
        patch :update, id: alice.id, user: {first_name: "Jane", last_name: "Doe", email: "alice@email.com", password: 'password'}
        expect(alice.first_name).not_to eq("Jane")
      end
    end
  end

  describe "POST update_payment" do
    context "for active users" do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
        request.env["HTTP_REFERER"] = "/account"
      end

      it "redirects to the account path for successful update" do
        result = double(:update_payment_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :update_payment
        expect(response).to redirect_to account_path
      end

      it "sets a success message for successful update" do
        result = double(:update_payment_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :update_payment
        expect(flash[:success]).to be_present
      end

      it "redirects back to the account path for unsuccessful update" do
        result = double(:update_payment_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :update_payment
        expect(response).to redirect_to account_path
      end

      it "sets an error message for unsuccessful update" do
        result = double(:update_payment_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :update_payment
        expect(flash[:error]).to be_present
      end
    end

    context "for inactive users" do
      it "redirects to the account path" do
        alice = Fabricate(:user, active: false)
        session[:user_id] = alice.id
        post :update_payment
        expect(response).to redirect_to account_path
      end
    end

    context "for admins" do
      it "redirects to the admin path" do
        alice = Fabricate(:admin)
        session[:user_id] = alice.id
        post :update_payment
        expect(response).to redirect_to admin_path
      end
    end

    context "for unauthenticated users" do
      it "redirects to the welcome path" do
        post :update_payment
        expect(response).to redirect_to welcome_path
      end
    end
  end

  describe "POST activate" do
    context "for inactive users" do
      let(:alice) { Fabricate(:user, active: false) }
      before do
        session[:user_id] = alice.id
        request.env["HTTP_REFERER"] = "/"
      end

      it "redirects to the account path for successful update and resubscribe" do
        result1 = double(:update_payment_result, successful?: true)
        result2 = double(:subscribe_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result1)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)

        post :activate, stripeToken: "sadfaskfjh"
        expect(response).to redirect_to account_path
      end

      it "sets a success message for successful update and resubscribe" do
        result1 = double(:update_payment_result, successful?: true)
        result2 = double(:subscribe_result, successful?: true)
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result1)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)

        post :activate, stripeToken: "sadfaskfjh"
        expect(flash[:success]).to be_present
      end

      it "redirects to the account path for successful resubscribe" do
        result = double(:subscribe_result, successful?: true)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result)

        post :activate
        expect(response).to redirect_to account_path
      end

      it "sets a success message for successful resubscribe" do
        result = double(:subscribe_result, successful?: true)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result)

        post :activate
        expect(flash[:success]).to be_present
      end

      it "redirects back to the root page for unsuccessful updates" do
        result = double(:update_payment_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :activate, stripeToken: "sadfaskfjh"
        expect(response).to redirect_to root_path
      end

      it "sets an error message for unsuccessful updates" do
        result = double(:update_payment_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result)
        post :activate, stripeToken: "sadfaskfjh"
        expect(flash[:error]).to be_present
      end

      it "redirects back to the root page for successful updates and unsuccessful subscriptions" do
        result1 = double(:update_payment_result, successful?: true)
        result2 = double(:subscribe_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result1)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)
        post :activate, stripeToken: "sadfaskfjh"
        expect(response).to redirect_to root_path
      end

      it "sets an error message for successful updates and unsuccessful subscriptions" do
        result1 = double(:update_payment_result, successful?: true)
        result2 = double(:subscribe_result, successful?: false, error_message: "Error!")
        UserUpdate.any_instance.should_receive(:update_payment).and_return(result1)
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)
        post :activate, stripeToken: "sadfaskfjh"
        expect(flash[:error]).to be_present
      end

      it "redirects back to the root page for unsuccessful subscriptions" do
        result2 = double(:subscribe_result, successful?: false, error_message: "Error!")
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)
        post :activate
        expect(response).to redirect_to root_path
      end

      it "sets an error message for successful updates and unsuccessful subscriptions" do
        result2 = double(:subscribe_result, successful?: false, error_message: "Error!")
        UserSubscription.any_instance.should_receive(:subscribe).and_return(result2)
        post :activate
        expect(flash[:error]).to be_present
      end
    end

    context "for active users" do
      it "redirects to the account path" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        post :activate
        expect(response).to redirect_to account_path
      end
    end

    context "for unauthenticated users" do
      it "redirects to the welcome path" do
        post :activate
        expect(response).to redirect_to welcome_path
      end
    end
  end

  describe "POST deactivate" do
    context "for active users" do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
        request.env["HTTP_REFERER"] = "/"
      end

      it "redirects to the account path for successful deactivation" do
        result = double(:unsubscribe_result, successful?: true)
        UserSubscription.any_instance.should_receive(:unsubscribe).and_return(result)
        post :deactivate
        expect(response).to redirect_to account_path
      end

      it "sets a success message for successful deactivation" do
        result = double(:unsubscribe_result, successful?: true)
        UserSubscription.any_instance.should_receive(:unsubscribe).and_return(result)
        post :deactivate
        expect(flash[:success]).to be_present
      end

      it "redirects back to the root path for unsuccessful deactivation" do
        result = double(:unsubscribe_result, successful?: false, error_message: "Error!")
        UserSubscription.any_instance.should_receive(:unsubscribe).and_return(result)
        post :deactivate
        expect(response).to redirect_to root_path
      end

      it "sets an error message for unsuccessful deactivation" do
        result = double(:unsubscribe_result, successful?: false, error_message: "Error!")
        UserSubscription.any_instance.should_receive(:unsubscribe).and_return(result)
        post :deactivate
        expect(flash[:error]).to be_present
      end
    end

    context "for inactive users" do
      it "redirects to the account path" do
        alice = Fabricate(:user, active: false)
        session[:user_id] = alice.id
        post :deactivate
        expect(response).to redirect_to account_path
      end
    end

    context "for admins" do
      it "redirects to the admin path" do
        alice = Fabricate(:admin)
        session[:user_id] = alice.id
        post :deactivate
        expect(response).to redirect_to admin_path
      end
    end

    context "for unauthenticated users" do
      it "redirects to the welcome path" do
        post :deactivate
        expect(response).to redirect_to welcome_path
      end
    end
  end

  describe "DELETE destroy" do
    context "for authenticated users" do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
        request.env["HTTP_REFERER"] = "/"
      end

      it "redirects to the register path for successful delete" do
        result = double(:delete_result, successful?: true)
        UserDelete.any_instance.should_receive(:delete).and_return(result)
        delete :destroy, id: alice.id
        expect(response).to redirect_to register_path
      end

      it "sets a success message for successful delete" do
        result = double(:delete_result, successful?: true)
        UserDelete.any_instance.should_receive(:delete).and_return(result)
        delete :destroy, id: alice.id
        expect(flash[:success]).to be_present
      end

      it "redirects back to the root path for unsuccessful delete" do
        result = double(:delete_result, successful?: false, error_message: "Error!")
        UserDelete.any_instance.should_receive(:delete).and_return(result)
        delete :destroy, id: alice.id
        expect(response).to redirect_to root_path
      end

      it "sets an error message for unsuccessful delete" do
        result = double(:delete_result, successful?: false, error_message: "Error!")
        UserDelete.any_instance.should_receive(:delete).and_return(result)
        delete :destroy, id: alice.id
        expect(flash[:error]).to be_present
      end
    end

    context "for unauthenticated users" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      it "redirects to the welcome page" do
        delete :destroy, id: alice.id
        expect(response).to redirect_to welcome_path
      end

      it "doesn't delete the user" do
        delete :destroy, id: alice.id
        expect(alice).to be_truthy
      end

      it "doesn't delete the user if another user is logged in" do
        session[:user_id] = bob.id
        request.env["HTTP_REFERER"] = "/"
        delete :destroy, id: alice.id
        expect(alice).to be_truthy
      end
    end
  end
end
