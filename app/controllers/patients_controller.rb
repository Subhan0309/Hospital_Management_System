class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  def index
    
    if current_user.role == 'doctor'
      @doctor=Doctor.find(current_user.id)
      @patients= @doctor.patients.paginate(page: params[:page],per_page:2)
      
 
    else
      @patients = User.where(hospital_id: ActsAsTenant.current_tenant.id, role: 'patient').paginate(page: params[:page],per_page:2)
    end

  end

  # GET /patients/1
  def show
    # You may want to display details of a single patient
  end

  # GET /patients/new
  def new
    @patient = Patient.new
    @patient.build_detail
  end

  # POST /patients
  def create
    @patient = Patient.new(patient_params)
    @patient.role= 'patient'
    if @patient.save
      UserMailer.welcome_email(@patient).deliver_now 
      redirect_to patients_path, notice: 'Patient was successfully created.'
    else
      render :new
    end
  end

  # GET /patients/1/edit
  def edit
    # You can use this to show an edit form for a patient
  end

  # PATCH/PUT /patients/1
  def update
    if @patient.update(patient_params)
      redirect_to patients_path, notice: 'Patient was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /patients/1
  def destroy
   if  @patient.destroy
    redirect_to patients_path, notice: 'Patient was successfully deleted.' 
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_patient
    @patient = Patient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(:name, :email,:password, :password_confirmation, :gender, :hospital_id,detail_attributes: [:id, :specialization, :qualification, :disease, :status, :_destroy]) # Add other permitted attributes here
  end
end
