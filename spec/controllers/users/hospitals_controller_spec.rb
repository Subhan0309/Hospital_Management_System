# require 'rails_helper'

# RSpec.describe HospitalsController, type: :controller do
#   let(:owner) { create(:user, role: 'owner') }
#   let(:admin) { create(:user, role: 'admin') }
#   let(:doctor) { create(:user, role: 'doctor') }
#   let(:patient) { create(:user, role: 'patient') }
#   let(:hospital) { create(:hospital, user: owner) }
#   let(:another_hospital) { create(:hospital, user: owner) }

#   before do
#     sign_in owner
#   end

#   describe 'GET #index' do
#     context 'when hospitals are present' do
#       it 'assigns @hospitals and renders the index template' do
#         get :index
#         expect(assigns(:hospitals)).to include(hospital, another_hospital)
#         expect(response).to render_template(:index)
#       end
#     end
#   end

#   #   context 'when no hospitals are present' do
#   #     it 'redirects to the sign-up page and returns a 404 JSON error' do
#   #       Hospital.delete_all # Clear existing hospitals
#   #       get :index
#   #       expect(response).to redirect_to(new_user_registration_path)
#   #       expect(response.content_type).to eq("application/json; charset=utf-8")
#   #       expect(response.body).to include('No hospitals found')
#   #     end
#   #   end
#   # end

#   # describe 'GET #show' do
#   #   it 'assigns the requested hospital to @hospital and renders the show template' do
#   #     get :show, params: { id: hospital.id }
#   #     expect(assigns(:hospital)).to eq(hospital)
#   #     expect(response).to render_template(:show)
#   #   end
#   # end

#   # describe 'GET #new' do
#   #   it 'assigns a new hospital to @hospital and renders the new template' do
#   #     get :new
#   #     expect(assigns(:hospital)).to be_a_new(Hospital)
#   #     expect(response).to render_template(:new)
#   #   end
#   # end

#   # describe 'POST #create' do
#   #   context 'when the user is an owner' do
#   #     it 'creates a new hospital and redirects to the hospitals path' do
#   #       expect {
#   #         post :create, params: { hospital: attributes_for(:hospital) }
#   #       }.to change(Hospital, :count).by(1)
#   #       expect(response).to redirect_to(hospitals_path)
#   #       expect(flash[:notice]).to eq('Hospital was successfully created.')
#   #     end
#   #   end

#   #   context 'when the user is not an owner' do
#   #     before { sign_in admin }

#   #     it 'does not create a hospital and renders plain text' do
#   #       post :create, params: { hospital: attributes_for(:hospital) }
#   #       expect(response.body).to include('You are not authorized to do this')
#   #       expect(response.content_type).to eq('text/plain; charset=utf-8')
#   #     end
#   #   end
#   # end

#   # describe 'GET #edit' do
#   #   it 'assigns the requested hospital to @hospital and renders the edit template' do
#   #     get :edit, params: { id: hospital.id }
#   #     expect(assigns(:hospital)).to eq(hospital)
#   #     expect(response).to render_template(:edit)
#   #   end
#   # end

#   # describe 'PATCH #update' do
#   #   context 'with valid attributes' do
#   #     it 'updates the hospital and redirects to the dashboard' do
#   #       patch :update, params: { id: hospital.id, hospital: { name: 'Updated Name' } }
#   #       hospital.reload
#   #       expect(hospital.name).to eq('Updated Name')
#   #       expect(response).to redirect_to(hospital_dashboard_path)
#   #       expect(flash[:notice]).to eq('Hospital was successfully Updated.')
#   #     end
#   #   end

#   #   context 'with invalid attributes' do
#   #     it 'does not update the hospital and re-renders the edit template' do
#   #       patch :update, params: { id: hospital.id, hospital: { name: nil } }
#   #       expect(response).to render_template(:edit)
#   #     end
#   #   end
#   # end

#   # describe 'DELETE #destroy' do
#   #   it 'deletes the hospital and redirects to the hospitals path' do
#   #     hospital # Create the hospital before deleting
#   #     expect {
#   #       delete :destroy, params: { id: hospital.id }
#   #     }.to change(Hospital, :count).by(-1)
#   #     expect(response).to redirect_to(hospitals_path)
#   #     expect(flash[:notice]).to eq('Hospital was successfully Destroyed.')
#   #   end
#   # end

#   # describe 'GET #dashboard' do
#   #   context 'for owners, admins, and staff' do
#   #     it 'assigns dashboard data and renders the dashboard template' do
#   #       get :dashboard
#   #       expect(assigns(:doctor_count)).to be_an(Integer)
#   #       expect(assigns(:patient_count)).to be_an(Integer)
#   #       expect(assigns(:admin_count)).to be_an(Integer)
#   #       expect(assigns(:staff_count)).to be_an(Integer)
#   #       expect(assigns(:appointments_by_day)).to be_a(Hash)
#   #       expect(assigns(:today_registrations)).to be_a(Hash)
#   #       expect(response).to render_template(:dashboard)
#   #     end
#   #   end

#   #   context 'for doctors' do
#   #     before { sign_in doctor }

#   #     it 'assigns dashboard data specific to doctors and renders the dashboard template' do
#   #       get :dashboard
#   #       expect(assigns(:appointments_by_day)).to be_a(Hash)
#   #       expect(assigns(:medical_records_by_day)).to be_a(Hash)
#   #       expect(assigns(:patients_count)).to be_an(Integer)
#   #       expect(response).to render_template(:dashboard)
#   #     end
#   #   end

#   #   context 'for patients' do
#   #     before { sign_in patient }

#   #     it 'assigns dashboard data specific to patients and renders the dashboard template' do
#   #       get :dashboard
#   #       expect(assigns(:appointments_by_day)).to be_a(Hash)
#   #       expect(assigns(:medical_records_by_day)).to be_a(Hash)
#   #       expect(assigns(:doctors_count)).to be_an(Integer)
#   #       expect(response).to render_template(:dashboard)
#   #     end
#   #   end
#   # end


# end
