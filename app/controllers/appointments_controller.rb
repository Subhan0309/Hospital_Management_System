class AppointmentsController < ApplicationController
  before_action :set_user
  before_action :set_specific_doctor_appointment, :set_specific_patient_appointment, only: [:index]
  before_action :set_doctors, only: [:new, :edit, :create, :update]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  
  def index
    
    if current_user.patient?

      if current_user.id == params[:user_id].to_i
        @appointments = @user.appointments
     
     else
      @appointments = @specific_doctor.appointments.where(patient_id: current_user.id)
     end
     elsif current_user.doctor?
      if current_user.id == params[:user_id].to_i
        @appointments = @user.appointments
     
     else
      @appointments = @specific_patient.appointments.where(doctor_id: current_user.id)
     end
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

  private

  def set_user
   @user = current_user.role == 'doctor' ? Doctor.find(params[:user_id]) : Patient.find(params[:user_id])
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
