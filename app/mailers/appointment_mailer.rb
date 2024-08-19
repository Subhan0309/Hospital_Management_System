class AppointmentMailer < ApplicationMailer
    default from: 'hms@gmail.com'

    def appointment_confirmation_patient
      @appointment = params[:appointment]
      @patient=Patient.find(@appointment.patient_id)
      @doctor=Doctor.find(@appointment.doctor_id)
      @start_time=@appointment.start_time
      @end_time=@appointment.end_time
      mail(
        to: @patient.email,
        subject: 'Appointment Confirmation'
      )
    end

    def appointment_confirmation_doctor
      @appointment = params[:appointment]
      @doctor=Doctor.find(@appointment.doctor_id)
      @patient=Patient.find(@appointment.patient_id)
      @start_time=@appointment.start_time
      @end_time=@appointment.end_time
      mail(
        to: @doctor.email,
        subject: 'Appointment Confirmation'
      )
    end

    def reminder_email_to_patient(appointment)
      @appointment = appointment
      @patient=Patient.find(@appointment.patient_id)
      mail(to: @patient.email, subject: 'Appointment Reminder')
    end
    def reminder_email_to_doctor(appointment)
      @appointment = appointment
      @doctor=Doctor.find(@appointment.doctor_id)
      mail(to: @doctor.email, subject: 'Appointment Reminder')
    end
  end
  

