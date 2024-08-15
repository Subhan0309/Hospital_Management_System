class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :edit, :update, :destroy, :update_availability_status]

  # GET /doctors
  def index
    if current_user.role == 'patient'
      @patient=Patient.find(current_user.id)
      @doctors= @patient.doctors.paginate(page: params[:page],per_page:2)
 
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
    @doctor.build_detail
  end

  def create
    @doctor = Doctor.new(doctor_params)
    
    @doctor.role = 'doctor' 
    if @doctor.save
      UserMailer.welcome_email(@doctor).deliver_now 
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
  
  def update_availability_status
     Rails.logger.debug "Incoming parameters: #{params.inspect}"
    if @doctor.update(availability_status_params)
      redirect_to user_appointments_path(@doctor), notice: 'Availability status was successfully updated.'
    else
      render :edit
    end
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def availability_status_params
    params.require(:user).permit(:availability_status)
  end

  def doctor_params
 
    params.require(:doctor).permit(:name, :email, :gender,:password, :password_confirmation, :hospital_id,  detail_attributes: [:id, :specialization, :qualification, :disease, :status, :_destroy])
  end
end
