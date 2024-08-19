class AppointmentChannel < ApplicationCable::Channel
  def subscribed
    doctor_id = params[:doctor_id]
    patient_id = params[:patient_id]
    oas_id = params[:oas_id]
    role = params[:role]

    if doctor_id.present?
      stream_from "appointment_channel_#{doctor_id}"
    elsif patient_id.present?
      stream_from "appointment_channel_#{patient_id}"
    elsif role.present?
      stream_from "appointment_channel_#{role}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
