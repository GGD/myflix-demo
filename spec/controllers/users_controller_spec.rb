require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      before { post :create, user: Fabricate.attributes_for(:user) }
      
      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "puts the user in session" do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "redirects to categories_path" do
        expect(response).to redirect_to categories_path
      end
    end

    context "with invalid inputs" do
      before do
        post :create, user: { password: '1234', full_name: 'Ga Dii' }
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "render :new template" do
        expect(response).to render_template :new
      end
    end
  end
end 