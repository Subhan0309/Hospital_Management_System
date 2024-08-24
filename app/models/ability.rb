# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
   
    user ||= User.new 


   
    if user.owner?
      can :manage, :all 
    end

    if user.admin?
      cannot :manage, User, role: 'owner'
      cannot [:destroy,:create,:update], User, role: 'admin'
      # cannot :manage,Hospital
      # can :read , Hospital
      can :manage,User,role: 'staff'
      can :manage, User, role: 'patient'
      can :manage, User, role: 'doctor'
      can :read , User, role: 'admin'
     
      # Can update only their own profile
      can :update, User, id: user.id


      
      # binding.pry
      can :manage, Appointment
      can :manage , Comment
      can :manage, MedicalRecord
  
     
      can :access, :all_appointments
      can :access, :all_medical_records
      can :access, :all_comments
    
    end

    if user.staff?
     

      cannot :manage, User ,role:'owner'
      cannot [:create,:delete,:update] , User, role: 'admin'
      cannot [:create,:delete,:update] , User, role: 'staff'
      # cannot :manage,Hospital
      # can :read , Hospital

      # can read others staff
      can :read,User,role:'staff'
      can :read , User, role: 'admin'

      # Can update only their own profile
      can :update, User, id: user.id

      can :manage,  User, role: 'patient'
      can :manage, User, role: 'doctor'

      can :manage, Appointment
      can :manage , Comment
      #can :manage, Attachment
      can :manage, MedicalRecord
    end


    if user.doctor?
     
      
      # Cannot manage users with specific roles
      cannot :manage, User, role: 'owner'
      cannot [:create, :delete, :update], User, role: 'admin'
      cannot [:create, :delete, :update], User, role: 'staff'
      cannot [:create, :delete], User, role: 'patient'
      cannot [:create, :delete, :update], User, role: 'doctor'
      # cannot :manage,Hospital
      # can :read , Hospital
      # Can read users with specific roles
      can :read, User, role: 'admin'
      can :read, User, role: 'staff'
      can [:read,:update], User, role: 'patient'
      can :read, User, role: 'doctor'
      
      # Can update only their own profile
      can [:update,:read], User, id: user.id
     
      # Can manage appointments, comments, and medical records
      can :manage, Appointment
      can :manage, Comment
      can :manage, MedicalRecord
    end
    

    if user.patient?
      
     
      cannot :manage, User, role: 'owner'
      cannot [:create,:delete,:update] , User, role: 'admin'
      cannot [:create,:delete,:update] , User, role: 'staff'
      cannot [:create,:delete,:update] , User, role: 'doctor'
      # cannot :manage,Hospital
      # can :read , Hospital

      can :read , User, role: 'admin'
      can :read , User, role: 'staff'
      can :read,  User, role: 'doctor'

      can [:read,:update] , User, role: 'patient'
      can [:read] , Users, role: 'patient'

      can :manage, Appointment
      can :manage , Comment
      # can :manage, Attachment
      can :manage, MedicalRecord
    end

  end
end
