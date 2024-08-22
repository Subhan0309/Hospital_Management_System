require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:valid_hospital_attributes) do
    {
      hospital_name: 'Test Hospital',
      hospital_location: 'Test Location',
      hospital_email: 'hospital@test.com',
      license_no: '12345',

    }
  end

  let(:valid_user_attributes) do
    {
      name: 'Test User',
      email: 'user@test.com',
      gender: 'male',
      role: 'owner',
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  let(:invalid_hospital_attributes) do
    valid_hospital_attributes.merge(hospital_name: nil)
  end

  let(:invalid_user_attributes) do
    valid_user_attributes.merge(email: nil)
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'assigns a new Hospital and User' do
      get :new
      expect(assigns(:hospital)).to be_a_new(Hospital)
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'returns a success response' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      subject do
        post :create, params: { user: valid_hospital_attributes.merge(valid_user_attributes) }
      end

      it 'creates a new Hospital' do
        expect do
          subject
        end.to change(Hospital, :count).by(1)
      end

      it 'creates a new User' do
        expect do
          subject
        end.to change(User, :count).by(1)
      end

      it 'redirects to the subdomain sign-in page' do
        subject
        hospital = assigns(:hospital)
        expect(response).to redirect_to("http://#{hospital.subdomain}.localhost:3000/en/users/sign_in")
      end

      it 'sets the correct hospital ID for the user' do
        subject
        user = assigns(:user)
        hospital = assigns(:hospital)
        expect(user.hospital_id).to eq(hospital.id)
      end
    end

    context 'with invalid hospital params' do
      subject do
        post :create, params: { user: invalid_hospital_attributes.merge(valid_user_attributes) }
      end

      it 'does not create a new Hospital' do
        expect do
          subject
        end.not_to change(Hospital, :count)
      end

      it 'does not create a new User' do
        expect do
          subject
        end.not_to change(User, :count)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to render_template(:new)
      end
    end

    context 'with invalid user params' do
      subject do
        post :create, params: { user: valid_hospital_attributes.merge(invalid_user_attributes) }
      end

      it 'does not create a new Hospital' do
        expect do
          subject
        end.to change(Hospital, :count).by(0)
      end

      it 'does not create a new User' do
        expect do
          subject
        end.not_to change(User, :count)
      end

      it 'destroys the created Hospital if user creation fails' do
        expect do
          subject
        end.to change(Hospital, :count).by(0)
      end

      it "re-renders the 'new' template with an alert" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end
end
