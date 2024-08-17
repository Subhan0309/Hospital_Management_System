class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: :profile
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
      doctor = Doctor.find(current_user.id)
      
      if doctor.update(user_params)
        flash[:notice] = "Doctor profile updated successfully."
        redirect_to users_path, notice: "Doctor was successfully updated."
      else
        flash.now[:alert] = "There was an error updating the doctor profile."
        render :profile
      end
      
    elsif current_user.patient?
      patient = Patient.find(current_user.id)
      
      if patient.update(user_params)
        flash[:notice] = "Patient profile updated successfully."
        redirect_to users_path, notice: "Patient was successfully updated."
      else
        flash.now[:alert] = "There was an error updating the patient profile."
        render :profile
      end
      
    else
      # Handle other user roles if necessary
      if @user.update(user_params)
        redirect_to users_path, notice: "User (#{user_params[:role]}) was successfully updated."
      else
        render :profile
      end
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




  private


  def user_params
    if current_user.doctor? || current_user.patient?
      params.require(:user).permit(:name, :email,:password, :password_confirmation, :gender, :hospital_id,:profile_picture,detail_attributes: [:id, :specialization, :qualification, :disease, :status, :_destroy])
    else
      params.require(:user).permit(:availability_status,:name, :email, :gender,:role,:password,:password_confirmation,:profile_picture)
    end
   
  end
  def find_user
    @user = User.find(params[:id])
  end

end
