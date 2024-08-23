set :output, "log/cron.log"

every 1.day, at: '9:00 pm' do
  runner "Appointment.send_daily_reminders"
end

every 1.day do
  rake "daily_summary:send_report"
end
