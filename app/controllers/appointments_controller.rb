class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_specific_doctor_appointment, :set_specific_patient_appointment, only: [:index]
  before_action :set_doctors, only: [:new, :edit, :create, :update]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]


  
  def index
    if current_user.patient?
      set_specific_doctor_appointment

      if current_user.id == params[:user_id].to_i
        @appointments = @user.appointments
     
     else
      @appointments = @specific_doctor.appointments.where(patient_id: current_user.id)
     end
    elsif current_user.doctor?
      @appointments = if current_user.id == params[:user_id].to_i
                        @user.appointments
                      else
                        @specific_patient.appointments.where(doctor_id: current_user.id)
                      end
    else
      @appointments = @user.appointments
    end
  end

  def show
     @appointment 
  end

  def new
    @appointment = @user.appointments.new

 
  end

  def create
    @appointment = @user.appointments.new(appointment_params)
   
    if @appointment.save
      AppointmentMailer.with(appointment: @appointment).appointment_confirmation_patient.deliver_now
      AppointmentMailer.with(appointment: @appointment).appointment_confirmation_doctor.deliver_now
      redirect_to user_appointments_path(@user), notice: 'Appointment was successfully created.'
    else
      flash.now[:alert] = 'Doctor is not available at this time'
      render :new, status: :unprocessable_entity
    end
  end

 
  def update
    if @appointment.update(appointment_params)
      redirect_to user_appointments_path(@user), notice: 'Appointment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @appointment.destroy
    redirect_to user_appointments_path(@user), notice: 'Appointment was successfully destroyed.'
  end

  def delete_all

    Appointment.where(doctor_id: current_user.id).destroy_all
    
    redirect_to user_appointments_path(@user), notice: 'All appointments were successfully deleted.'
  end

  def available_doctors
    start_time = params[:start_time]
    end_time = params[:end_time]
  
    doctors = Doctor.where(availability_status: 'available',role: 'doctor').map do |doctor|
      appointments_conflict = doctor.appointments.where("startTime < ? AND endTime > ?", end_time, start_time).exists?
      {
        id: doctor.id,
        name: doctor.name,
        availability: appointments_conflict ? 'Not Available' : 'Available'
      }
    end

    render json: doctors
  end
  
  private

  def set_user
   @user = User.find(params[:user_id])
   if @user.role == "doctor"
    @user=Doctor.find(params[:user_id])
   else
    @user=Patient.find(params[:user_id])
  end
end
  def set_doctors
    @doctors = User.where(hospital_id: current_user.hospital_id, role:"doctor")
  end
  
  def set_specific_doctor_appointment

    @specific_doctor = Doctor.find(params[:user_id])

  end
  def set_specific_patient_appointment

    @specific_patient = Patient.find(params[:user_id])

  end

  
  def set_appointment
    @appointment = @user.appointments.find(params[:id])

  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :doctor_id, :start_time, :end_time, :status)
  end
end
