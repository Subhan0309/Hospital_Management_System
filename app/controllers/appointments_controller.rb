class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user ,except: :all_appointments
  before_action :set_specific_doctor_appointment, :set_specific_patient_appointment, only: [:index]
  before_action :set_doctors, only: [:new, :edit, :create, :update]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access ,only: :all_appointments

  
  def index
    if current_user.patient?
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
      # Notify both doctor and patient
      notify_users('create', @appointment)
      
      redirect_to user_appointments_path(@user), notice: 'Appointment was successfully created.'
    else
      flash.now[:alert] = 'Doctor is not available at this time'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    case params[:appointment][:status]
    when 'completed'
      @appointment.complete!
    when 'canceled'
     @appointment.canceled!
    when 'scheduled'
      @appointment.reschedule! if @appointment.may_reschedule?
    end
    if @appointment.update(appointment_params)
      notify_users('update', @appointment)
      redirect_to user_appointments_path(@user), notice: 'Appointment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @appointment.destroy
    # Notify both doctor and patient
      notify_users('destroy', @appointment)
    
      redirect_to user_appointments_path(@user), notice: 'Appointment was successfully destroyed.'
    else
       redirect_to user_appointments_path(@user), notice: 'Appointment is not destroyedπ.'
    end
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
  
  def all_appointments
   
    if current_user.owner? || current_user.admin?
      appointments = Appointment.all

      # Paginate the ActiveRecord relation
      @paginated_appointments = appointments.paginate(page: params[:page], per_page: 12)

      # Map the paginated appointments to the desired hash structure
      @appointments = @paginated_appointments.map do |appointment|
        {
          id: appointment.id,
          start_time: appointment.start_time,
          end_time: appointment.end_time,
          status: appointment.status,
          patient_name: appointment.patient.name,
          doctor_name: appointment.doctor.name,
          patient_email: appointment.patient.email,
          doctor_email: appointment.doctor.email,
          hospital_id: appointment.hospital_id
        }
      end

    else
      redirect_to root_path, alert: 'You do not have access to this resource'
    end
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
  
  def notify_users(action, appointment)
    # Broadcast to the doctor's channel
    ActionCable.server.broadcast("appointment_channel_#{appointment.doctor_id}", {
      action: action,
      appointment: {
        id: appointment.id,
        date: appointment.start_time.to_s(:db),
        doctor_id: appointment.doctor_id,
        patient_id: appointment.patient_id,
        html: render_to_string(partial: 'appointments/appointment', locals: { appointment: appointment, user: @user })
      }
    })

    # Broadcast to the patient's channel
    ActionCable.server.broadcast("appointment_channel_#{appointment.patient_id}", {
      action: action,
      appointment: {
        id: appointment.id,
        date: appointment.start_time.to_s(:db),
        doctor_id: appointment.doctor_id,
        patient_id: appointment.patient_id,
        html: render_to_string(partial: 'appointments/appointment', locals: { appointment: appointment, user: @user })
      }
    })

    # Broadcast to specific role-based channels
    ['owner', 'admin', 'staff'].each do |role|

      ActionCable.server.broadcast("appointment_channel_#{role}", {
        action: action,
        appointment: {
          id: appointment.id,
          date: appointment.start_time.to_s(:db),
          doctor_id: appointment.doctor_id,
          patient_id: appointment.patient_id,
          html: render_to_string(partial: 'appointments/appointment', locals: { appointment: appointment, user: @user })
        }
      })
    end

  end
  def authorize_access
    authorize! :access, :all_appointments
  end

end
