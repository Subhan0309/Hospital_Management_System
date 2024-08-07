class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  def index
    @patients = User.where(hospital_id: ActsAsTenant.current_tenant,role: "patient")

  end

  # GET /patients/1
  def show
    # You may want to display details of a single patient
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # POST /patients
  def create
    @patient = Patient.new(patient_params)

    if @patient.save
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
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_patient
    @patient = Patient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(:name, :email, :hospital_id) # Add other permitted attributes here
  end
end
