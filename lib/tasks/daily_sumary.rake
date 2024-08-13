namespace :daily_summary do
  desc "Send daily summary report"
  task send_report: :environment do
    # Define the date range for the summary
    today = Date.current
    yesterday = today - 1.day

    # Fetch data
    appointments = Appointment.where(created_at: yesterday.beginning_of_day..yesterday.end_of_day)
    new_users = User.where(created_at: yesterday.beginning_of_day..yesterday.end_of_day)
   

    # Generate report content
    report_content = "Daily Summary Report for #{yesterday.strftime('%B %d, %Y')}\n\n"
    report_content += "Appointments Made:\n"
    appointments.each do |appointment|
      patient= Patient.find(appointment.patient_id)
      doctor= Doctor.find(appointment.doctor_id)
      report_content += "- Appointment ID: #{appointment.id}, Patient: #{patient.name}, Doctor ID: #{doctor.name}, Time: #{appointment.start_time}\n"
    end
    report_content += "\nNew Users Created:\n"
    new_users.each do |user|
      report_content += "-  Name: #{user.name}, Email: #{user.email}, Role:#{user.role} \n"
    end

    # Send email
    DailySummaryMailer.with(report: report_content).summary_email.deliver_now
  end
end
