class AppointmentMailer < ApplicationMailer
    default from: 'hms@gmail.com'
  
    def appointment_confirmation
      @appointment = params[:appointment]
      @patient=User.find(@appointment.patient_id)
      @doctor=User.find(@appointment.doctor_id)
      @start_time = @appointment.start_time
      @end_time = @appointment.end_time
  
      mail(
        to: @patient.email,
        subject: 'Appointment Confirmation'
      )
    end

    def reminder_email(appointment)
      @appointment = appointment
      @patient=User.find(@appointment.patient_id)
      mail(to: @patient.email, subject: 'Appointment Reminder')
    end
  end
  

