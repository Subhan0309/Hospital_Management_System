class CommentMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def comment_notification(medical_record, comment)
    @medical_record = medical_record
    @patient = Patient.find(@medical_record.patient_id)
    @comment = comment
    mail(to: @patient.email, subject: 'New Comment Added to Your Medical Record')
  end
end
