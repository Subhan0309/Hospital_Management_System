require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:hospital) { create(:hospital) }
  let!(:admin_user) {ActsAsTenant.with_tenant(hospital) { create(:user, :admin, hospital: hospital,email:'admin@gmail.com') }}
  let!(:doctor_user) {ActsAsTenant.with_tenant(hospital) { create(:user, :doctor, hospital: hospital,email:'doctor@gmail.com') }}
  let!(:patient_user) {ActsAsTenant.with_tenant(hospital) { create(:user, :patient, hospital: hospital,email:'patient@gmail.com') }}
  let!(:staff_user) { ActsAsTenant.with_tenant(hospital) { create(:user, :staff, hospital: hospital,email:'staff@gmail.com') }}

  before do
    ActsAsTenant.current_tenant = hospital
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'assigns @users and paginates them' do
      get :index
      expect(assigns(:users)).to match_array([admin_user, staff_user])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      get :show, params: { id: admin_user.id }
      expect(assigns(:user)).to eq(admin_user)
    end

    it 'renders the show template' do
      get :show, params: { id: admin_user.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new User to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: attributes_for(:user, hospital_id: hospital.id, role: 'staff') }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the users index with a success notice' do
        post :create, params: { user: attributes_for(:user, hospital_id: hospital.id, role: 'staff') }
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('User (staff) was Successfully created')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: attributes_for(:user, name: nil) }
        }.to_not change(User, :count)
      end

      it 're-renders the new template with errors' do
        post :create, params: { user: attributes_for(:user, name: nil) }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: admin_user.id }
      expect(assigns(:user)).to eq(admin_user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: admin_user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the user and redirects with a notice' do
        patch :update, params: { id: admin_user.id, user: { name: 'Updated Name' } }
        admin_user.reload
        expect(admin_user.name).to eq('Updated Name')
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('User () was successfully updated.')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user and re-renders the profile template with errors' do
        patch :update, params: { id: admin_user.id, user: { name: '' } }
        expect(response).to render_template(:profile)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user and redirects to users index with a notice' do
      expect {
        delete :destroy, params: { id: staff_user.id }
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq('User was successfully Destroyed.')
    end
  end

  describe 'GET #profile' do
    context 'as another user role' do
      it 'assigns current_user to @user and renders the profile template' do
        get :profile
        expect(assigns(:user)).to eq(admin_user)
        expect(response).to render_template(:profile)
      end
    end
  end


end
