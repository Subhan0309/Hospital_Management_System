class CommentMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def comment_notification(commentable, comment)
    @commentable = commentable
    if @commentable.is_a?(MedicalRecord)
      @user=Patient.find(@commentable.patient_id)
    else
      @user = User.find(@commentable.id)
    end
    @comment = comment
    mail(to: @user.email, subject: 'New Comment Added to Your Medical Record')
  end
end