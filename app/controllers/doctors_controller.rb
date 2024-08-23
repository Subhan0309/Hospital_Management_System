class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor, only: [:show, :edit, :update, :destroy, :update_availability_status]

 
def index
  # Initialize the query scope for doctors
  doctor_query = Doctor.joins(:detail)


  # Apply doctor filter based on user type and selected filter option
  if current_user.patient?
    if params[:doctor_filter] == 'my_doctors' and params[:speciality].present?
      @doctors=Doctor.joins(:appointments).where(appointments: { patient_id: current_user.id }).joins(:detail).where(details: { specialization: params[:speciality] }).paginate(page: params[:page],per_page:2)
     
    elsif params[:doctor_filter] == 'my_doctors' and !params[:speciality].present?
   
      @patient=Patient.find(current_user.id)
      @doctors= @patient.doctors.distinct.paginate(page: params[:page],per_page:2)
    elsif params[:doctor_filter] == 'all_doctors' and params[:speciality].present?
    
      @doctors = doctor_query.where(details: { specialization: params[:speciality] }).paginate(page: params[:page], per_page: 2)
    else 
      @doctors = User.where(role: "doctor")
      .paginate(page: params[:page], per_page: 2)
    end
  else
     # Apply speciality filter if provided
    if params[:speciality].present?
      
      @doctors = doctor_query.where(details: { specialization: params[:speciality] }).paginate(page: params[:page], per_page: 2)
    else
      @doctors = User.where(role: "doctor")
      .paginate(page: params[:page], per_page: 2)
    end
   
  end
 

  # Retrieve all distinct specialities for filtering options
  @specialities = Doctor.joins(:detail)
                        .distinct
                        .pluck('details.specialization')
end

  def show
    
  end

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
  def edit

  end


  def update

    if @doctor.update(doctor_params)
      redirect_to doctors_path, notice: 'Doctor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if  @doctor.destroy
      redirect_to doctors_path, notice: 'Doctor was successfully deleted.' 
      end
  end
  
  def update_availability_status
     Rails.logger.debug "Incoming parameters: #{params.inspect}"
    if @doctor.update(availability_status_params)
      
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
    params.permit(:availability_status) # Directly permit availability_status since it's not nested
  end
  def doctor_params
 
    params.require(:doctor).permit(:name, :email, :gender,:password, :password_confirmation, :hospital_id,  detail_attributes: [:id, :specialization, :qualification, :disease, :status, :_destroy])
  end
end
