# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
   
    user ||= User.new 

    puts "Hi i am a "+ user.inspect

   
    if user.owner?
      can :manage, :all 
    end

    if user.admin?
      puts "Hi i am an admin"
      
      cannot :manage, User, role: 'owner'
      cannot [:destroy,:create,:update], Users, role: 'admin'
      can :manage,User,role: 'staff'
      can :manage,  User, role: 'patient'
      can :manage, User, role: 'doctor'
      can :read , Users, role: 'admin'
      can :read , User, role: 'admin'
      can :update, User, role: 'admin'


      
      # binding.pry
      # can :manage, Appointment
      # can :manage , Comment
  
      # # can :manage, Attachment
      
      # can :manage, MedicalRecord
    end

    if user.staff?
        puts "Hi i am staff"



      
      cannot [:create,:delete,:update] , User, role: 'admin'
      cannot :manage, User ,role:'owner'
      cannot [:create,:delete,:update] , Users, role: 'staff'
      can :read , User, role: 'admin'
      can :read,Users,role:'staff'
      can :read , User, role: 'staff'


      # can :manage, Appointment
      # can :manage , Comment
      can :manage,  User, role: 'patient'
      can :manage, User, role: 'doctor'
      # can :manage, Attachment
      # can :manage, MedicalRecord
    end


    if user.doctor?
       puts "Hi i am an doctor"
      cannot :manage, User, role: 'owner'
      cannot [:create,:delete,:update] , User, role: 'admin'
      cannot [:create,:delete,:update] , User, role: 'staff'
      cannot [:create,:delete,:update] , User,role: 'patient'


      can :read , User, role: 'admin'
      can :read , User, role: 'staff'
      can :read,  User, role: 'patient'

      # can :manage, Appointment
      # can :manage , Comment
      can :manage, User, role: 'doctor'
      # can :manage, Attachment
      # can :manage, MedicalRecord
    end


    if user.patient?
       puts "Hi i am an patient"
      cannot :manage, User, role: 'owner'
      cannot [:create,:delete,:update] , User, role: 'admin'
      cannot [:create,:delete,:update] , User, role: 'staff'
      cannot [:create,:delete,:update] , User, role: 'doctor'


      can :read , User, role: 'admin'
      can :read , User, role: 'staff'
      can :read,  User, role: 'doctor'

      # can :manage, Appointment
      # can :manage , Comment
      # can :manage, Attachment
      # can :manage, MedicalRecord
    end

  end
end
