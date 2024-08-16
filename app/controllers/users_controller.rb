class UsersController < ApplicationController
  load_and_authorize_resource except: :profile

  before_action :authenticate_user!
  before_action :find_user, only: [:update, :edit, :show, :destroy]
  
  def index
      @users = User.where(role: ['admin', 'staff']).paginate(page: params[:page],per_page:2)
   
  end

  def show
   
  end
  def new
    @user=User.new()
  end

  def create
   
    @user=User.new(user_params)
    @user.hospital_id=ActsAsTenant.current_tenant.id
    if @user.save
      UserMailer.welcome_email(@patient).deliver_now 
      redirect_to users_path,notice: "User (#{user_params[:role]}) was Successfully created"
    else
       # Render the new template again with errors
       render :new, alert: @user.errors.full_messages.to_sentence
    end

  end

  def edit
  end


  def update
    if current_user.doctor?
      # Redirect to the doctor's profile action in the DoctorsController
      redirect_to edit_doctor_path(current_user.id) and return
    elsif current_user.patient?
      # Redirect to the patient's profile action in the PatientsController
      redirect_to edit_patient_path(current_user.id) and return
    end

    if @user.update(user_params)
      redirect_to users_path,notice: "User (#{user_params[:role]}) was Successfully Updated "
    else
      # If the update fails (e.g., due to validation errors), render the edit form again
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path,notice: 'User was successfully Destroyed.'
    else
      redirect_to users_path,notice: 'There is an error in deleting a user'
    end
  end

  def profile
    if current_user.doctor? || current_user.patient? 
      
      @user=current_user
      @details=Detail.where(associated_with_id: current_user.id)
    else
      @user = current_user      
    end

  end
  
 
  def update_availability_status
    if @user.update(user_params)
      redirect_to user_appointments_path(@user), notice: 'Availability status was successfully updated.'
    else
      render :edit
    end
  end
  # def destroy
  #   # binding.pry
  #   @user = User.find(params[:id])
  #   @user.destroy
  #   redirect_to users_path, notice: 'User was successfully deleted.'
  # rescue CanCan::AccessDenied
  #   redirect_to users_path, alert: 'Access denied. You are not authorized to delete this user.'
  # end



  private


  def user_params
    params.require(:user).permit(:availability_status,:name, :email, :gender,:role,:password,:password_confirmation,:profile_picture)
  end
  def find_user
    @user = User.find(params[:id])
  end

end
