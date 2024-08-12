class AppointmentsController < ApplicationController
  before_action :set_user
  before_action :set_doctors, only: [:new, :edit, :create, :update]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def self.send_daily_reminders
    tomorrow = Date.tomorrow
    appointments = Appointment.where(start_time: tomorrow.beginning_of_day..tomorrow.end_of_day)

    appointments.each do |appointment|
      AppointmentMailer.reminder_email(appointment).deliver_now
    end
  end
  def index

    @appointments = @user.appointments
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
      AppointmentMailer.with(appointment: @appointment).appointment_confirmation.deliver_now
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
  
  
  def set_appointment
    @appointment = @user.appointments.find(params[:id])

  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :doctor_id, :start_time, :end_time, :status)
  end
end
