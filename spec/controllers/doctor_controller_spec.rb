require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do
  let!(:hospital) { create(:hospital) }
  let!(:admin_user) {ActsAsTenant.with_tenant(hospital) { create(:user, :admin, hospital: hospital,email:'admin@gmail.com') }}
  let(:doctor) { create(:doctor, hospital: hospital) }  
  let!(:patient) {create(:patient, hospital: hospital) }  
  let(:detail) { create(:detail ,associated_with: doctor)}
  before do
    sign_in(doctor)
    sign_in(patient)
  end

  describe "GET #index" do

  context 'when patient is logged in' do
    it "assigns @doctors when my_doctors filter is applied without speciality" do
      get :index, params: { doctor_filter: 'my_doctors' }
      expect(assigns(:doctors)).not_to be_nil
    end

    it 'assigns @doctors when all_doctors filter is applied with speciality' do
      get :index, params: { doctor_filter: 'all_doctors', speciality: detail.specialization }
      expect(assigns(:doctors)).to include(doctor)
    end
  end

  context 'when another user is logged in' do
   

    before do
      sign_in(admin_user)
    end

    it 'assigns @doctors with or without speciality' do
      get :index, params: { speciality: detail.specialization }
      expect(assigns(:doctors)).to include(doctor)
    end
  end
end


  describe 'GET #show' do
    it 'assigns the requested doctor to @doctor' do
      get :show, params: { id: doctor.id }
      expect(assigns(:doctor)).to eq(doctor)
    end
  end

  describe 'GET #new' do
    it 'assigns a new doctor to @doctor' do
      get :new
      expect(assigns(:doctor)).to be_a_new(Doctor)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new doctor' do
        expect {
    post :create, params: { doctor: attributes_for(:doctor, hospital_id: hospital.id).merge(detail_attributes: attributes_for(:detail)) }
  }.to change(Doctor, :count).by(1)
      end

      it 'redirects to the doctors_path' do
        post :create, params: { doctor: attributes_for(:doctor,hospital_id: hospital.id).merge(detail_attributes: attributes_for(:detail)) }
        expect(response).to redirect_to(doctors_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new doctor' do
        expect {
          post :create, params: { doctor: attributes_for(:doctor, email: nil) }
        }.to_not change(Doctor, :count)
      end

      it 're-renders the new template' do
        post :create, params: { doctor: attributes_for(:doctor, email: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the doctor' do
        patch :update, params: { id: doctor.id, doctor: { name: 'New Name' } }
        doctor.reload
        expect(doctor.name).to eq('New Name')
      end

      it 'redirects to the doctors_path' do
        patch :update, params: { id: doctor.id, doctor: { name: 'New Name' } }
        expect(response).to redirect_to(doctors_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the doctor' do
        patch :update, params: { id: doctor.id, doctor: { email: nil } }
        doctor.reload
        expect(doctor.email).to_not be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { id: doctor.id, doctor: { email: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the doctor' do
      doctor # Create the doctor
      expect {
        delete :destroy, params: { id: doctor.id }
      }.to change(Doctor, :count).by(-1)
    end

    it 'redirects to doctors_path' do
      delete :destroy, params: { id: doctor.id }
      expect(response).to redirect_to(doctors_path)
    end
  end

  describe 'PATCH #update_availability_status' do
    it 'updates the availability status' do
      patch :update_availability_status, params: { id: doctor.id, availability_status: 'available' }
      doctor.reload
      expect(doctor.availability_status).to eq('available')
    end
  end
end
