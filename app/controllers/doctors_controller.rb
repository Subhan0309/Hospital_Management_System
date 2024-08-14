class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]

  # GET /doctors
  def index
    if current_user.role == 'patient'
      @patient=Patient.find(current_user.id)
      @doctors= @patient.doctors
      
 
    else
    @doctors=User.all.where(hospital_id:ActsAsTenant.current_tenant , role:"doctor").paginate(page: params[:page],per_page:2)
    end
  end

  # GET /doctors/1
  def show
    
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)
    
    @doctor.role = 'doctor' 
    if @doctor.save
      redirect_to doctors_path, notice: 'Doctor was successfully created.'
    else
      render :new
    end
  end
  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors
  

  # PATCH/PUT /doctors/1
  def update
    if @doctor.update(doctor_params)
      redirect_to doctors_path, notice: 'Doctor was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /doctors/1
  def destroy
    if  @doctor.destroy
      redirect_to doctors_path, notice: 'Doctor was successfully deleted.' 
      end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:name, :email, :gender,:password, :password_confirmation, :hospital_id) # Add other permitted attributes here
  end
end
