class DailySummaryMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def summary_email
    @report = params[:report]
    mail(to: 'owner@example.com', subject: 'Daily Summary Report')
  end
end
