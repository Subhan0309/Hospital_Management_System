
module ApplicationHelper
  def add_comment_path(item)
    
    case item.role

    when 'doctor'
      doctor_comments_path(item)
    when 'patient'
      patient_comments_path(item)
    when 'user'
      user_comments_path(item)
    else
      '#'
    end
  end

  def comment_form_url(user)
    if user.patient?
      patient_comments_path(user)
    elsif user.doctor?
      doctor_comments_path(user)
    elsif user.admin? || user.staff?
      user_comments_path(user)
    end
  end
end

