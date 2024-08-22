require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      subject do
        post :create, params: { user: { email: user.email, password: user.password } }
      end

      it 'signs in the user' do
        expect(controller.current_user).to be_nil
        subject
        expect(controller.current_user).to eq(user)
      end
    end

    context 'with invalid credentials' do
      subject do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
      end

      it 'does not sign in the user' do
        expect(controller.current_user).to be_nil
        subject
        expect(controller.current_user).to be_nil
      end

      it "re-renders the 'new' template with an alert" do
        subject
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
    end

    it 'signs out the user' do
      expect(controller.current_user).to eq(user)
      delete :destroy
      expect(controller.current_user).to be_nil
    end

    it 'redirects to the root path' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
