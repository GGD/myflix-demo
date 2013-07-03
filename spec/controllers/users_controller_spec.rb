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

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "sends out the email with valid inputs" do
        post :create, user: { email: 'tifa@example.com', password: '1234', full_name: 'Tifa FF' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['tifa@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'tifa@example.com', password: '1234', full_name: 'Tifa FF' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Tifa FF')
      end

      it "does not send out email with invalid inputs " do
        post :create, user: { email: 'tifa@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
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

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let (:action) { get :show, id: 1 }
    end

    it "assigns @user" do
      set_current_user
      tifa = Fabricate(:user)
      get :show, id: tifa.id
      expect(assigns(:user)).to eq(tifa)
    end
  end
end 