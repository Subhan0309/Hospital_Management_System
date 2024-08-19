class Appointment < ApplicationRecord
  alias_attribute :start_time, :startTime
  alias_attribute :end_time, :endTime
  
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  validates :startTime, :endTime, :doctor_id, :patient_id, presence: true
  validate :end_time_after_start_time

  enum status: { scheduled: 'scheduled', canceled: 'canceled', completed: 'completed' }
  
  include AASM
  aasm column: 'status' do
    state :scheduled, initial: true
    state :completed
    state :canceled
    event :complete do
      transitions from: :scheduled, to: :completed
    end
    event :cancel do
      transitions from: :scheduled, to: :canceled
    end
    event :reschedule do
      transitions from: :canceled, to: :scheduled
    end
  end


  def start_time_in_future
    if startTime.present? && startTime < Date.today
      errors.add(:startTime, "must be on or after today")
    end
  end
  def end_time_after_start_time
    if startTime.present? && endTime.present? && endTime <= startTime
      errors.add(:endTime, "must be after the start time")
    end
  end


  
  # def no_conflicting_appointments
  #    conflicts = Appointment.where(doctor_id: doctor_id).where.not(id: id)
  #                           .where("startTime < ? AND endTime > ?", endTime, startTime)
  #   if conflicts.exists?
  #       errors.add(:base, 'Doctor is not available at this time')
  #   end  
  # end

  def self.send_daily_reminders
    tomorrow = Date.tomorrow
    appointments = Appointment.where(start_time: tomorrow.beginning_of_day..tomorrow.end_of_day)

    appointments.each do |appointment|
      AppointmentMailer.reminder_email(appointment).deliver_now
    end
  end



end
