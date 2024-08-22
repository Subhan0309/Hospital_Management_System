class HospitalsController < ApplicationController
  
  before_action :authenticate_user! ,except: [:index]
  before_action :set_hospital, only: [:update, :edit, :show, :destroy]

  def index
    # Find all users with the provided email
    users_with_email = User.where(email: params[:email])
    
    # Extract the user_ids from the found users
    user_ids = users_with_email.pluck(:id)
    
    # Find all hospitals associated with these user_ids
    @hospitals = Hospital.where(user_id: user_ids).paginate(page: params[:page],per_page:5)

    respond_to do |format|
      if @hospitals.empty?
        # Redirect to the sign-up page if no hospitals are found
        format.html { redirect_to new_user_registration_path and return }
        format.json { render json: { error: 'No hospitals found' }, status: :not_found }
      # elsif @hospitals.size == 1 #change happen here
      #   format.html {
      #     subdomain = @hospitals[0].subdomain
      #     redirect_to "http://#{subdomain}.localhost:3000/users/sign_in" and return
      #   }
      #   format.json { render json: @hospitals }
      
      else
        # Render the index view or JSON response as appropriate
        format.html { render :index }
        format.json { render json: @hospitals }
      end
    end
  end

  def show
   
  end

  def profile
    
    @hospital=ActsAsTenant.current_tenant
  end

  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = Hospital.new(hospital_params)
    if current_user.role == "owner"
      if @hospital.save
      redirect_to hospitals_path,notice: 'Hospital was successfully created.'
      else
        return render :new
      end
    else
      render plain: "You are not authorized to do this"
    end
  end

  def edit
    @hospital = Hospital.find(params[:id])
  end
  
  def update
    if @hospital.update(hospital_params)
      redirect_to hospital_dashboard_path,notice: 'Hospital was successfully Updated.'
    else
      # If the update fails (e.g., due to validation errors), render the edit form again
      render :edit
    end
  end

  def destroy
    if @hospital.destroy
      redirect_to hospitals_path,notice: 'Hospital was successfully Destroyed.'
    else
      redirect_to hospitals_path,notice: 'There is an error in deleting a Hospital'
    end
  end

  def dashboard
    
    @user = current_user

    case @user.role
   when 'owner', 'admin', 'staff'
      @doctor_count = User.where(role: 'doctor').count
      @patient_count = User.where(role: 'patient').count
      @admin_count = User.where(role: 'admin').count
      @staff_count = User.where(role: 'staff').count
      @appointments_by_day = Appointment.group_by_day(:startTime).count


      @today_registrations = {
        staff: User.where(role: 'staff').where('created_at >= ?', Time.zone.now.beginning_of_day).count,
        admins: User.where(role: 'admin').where('created_at >= ?', Time.zone.now.beginning_of_day).count,
        doctors: User.where(role: 'doctor').where('created_at >= ?', Time.zone.now.beginning_of_day).count,
        patients: User.where(role: 'patient').where('created_at >= ?', Time.zone.now.beginning_of_day).count
      }


    when 'doctor'
      @appointments_by_day = Appointment.where(doctor: @user).group_by_day(:startTime).count
      @medical_records_by_day = MedicalRecord.where(doctor: @user).group_by_day(:created_at).count
      @patients_count = Patient.joins(:appointments).where(appointments: { doctor_id: @user.id }).distinct.count
    
    when 'patient'
      @appointments_by_day = Appointment.where(patient: @user).group_by_day(:startTime).count
      @medical_records_by_day = MedicalRecord.where(patient: @user).group_by_day(:created_at).count
      @doctors_count = Doctor.joins(:appointments).where(hospital_id: @user.hospital_id).distinct.count
    end

  end
  

  private

  def set_hospital
    @hospital = Hospital.find(params[:id])
    
  end

  def hospital_params
    params.require(:hospital).permit(:name, :location, :email, :license_no,:user_id,:logo)
  end
end
