class Appointment < ApplicationRecord
  alias_attribute :start_time, :startTime
  alias_attribute :end_time, :endTime
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  validates :startTime, :endTime, :doctor_id, :patient_id, presence: true
  validate :no_conflicting_appointments

  def no_conflicting_appointments
     conflicts = Appointment.where(doctor_id: doctor_id).where.not(id: id)
                            .where("startTime < ? AND endTime > ?", endTime, startTime)
    if conflicts.exists?
        errors.add(:base, 'Doctor is not available at this time')
    end  
  end

  def self.send_daily_reminders
    tomorrow = Date.tomorrow
    appointments = Appointment.where(start_time: tomorrow.beginning_of_day..tomorrow.end_of_day)

    appointments.each do |appointment|
      AppointmentMailer.reminder_email(appointment).deliver_now
    end
  end

  enum status: { scheduled: 0, canceled: 1, completed: 2 }

end
