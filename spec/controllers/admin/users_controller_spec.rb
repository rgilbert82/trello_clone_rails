require 'spec_helper'

describe Admin::UsersController do
  describe "DELETE destroy" do
    context "with valid admin" do
      let(:alice) { Fabricate(:admin) }
      let(:bob) { Fabricate(:user) }
      before { session[:user_id] = alice.id }
      before { request.env["HTTP_REFERER"] = "/admin/users" }
      before { delete :destroy, id: bob.id }

      it "deletes the user" do
        expect(User.count).to eq(1)
      end

      it "redirects back to the users index" do
        expect(response).to redirect_to admin_users_path
      end
    end

    context "with invalid admin" do
      before { request.env["HTTP_REFERER"] = "/admin/users" }

      it "doesn't delete a user for unauthenticated users" do
        bob = Fabricate(:user)
        delete :destroy, id: bob.id
        expect(User.count).to eq(1)
      end

      it "doesn't allow non-admins to delete users" do
        alice = Fabricate(:admin)
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        delete :destroy, id: alice.id
        expect(User.count).to eq(2)
      end

      it "redirects to the root path" do
        bob = Fabricate(:user)
        delete :destroy, id: bob.id
        expect(response).to redirect_to root_path
      end

      it "sets an error message" do
        bob = Fabricate(:user)
        delete :destroy, id: bob.id
        expect(flash[:error]).to eq("You are not authorized to do that.")
      end
    end
  end
end
