class HospitalsController < ApplicationController
  before_action :authenticate_user! ,except: [:index]
  before_action :set_hospital, only: [:update, :edit, :show, :destroy]

  def index
    # Find all users with the provided email
    users_with_email = User.where(email: params[:email])
    
    # Extract the user_ids from the found users
    user_ids = users_with_email.pluck(:id)
    
    # Find all hospitals associated with these user_ids
    @hospitals = Hospital.where(user_id: user_ids)

    respond_to do |format|
      if @hospitals.empty?
        # Redirect to the sign-up page if no hospitals are found
        format.html { redirect_to new_user_registration_path and return }
        format.json { render json: { error: 'No hospitals found' }, status: :not_found }
      else
        # Render the index view or JSON response as appropriate
        format.html { render :index }
        format.json { render json: @hospitals }
      end
    end
  end

  def show
   
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
      redirect_to hospitals_path,notice: 'Hospital was successfully Updated.'
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
    # respond_to do |format|

    #   format.html { render plain: "I am at #{ActsAsTenant.current_tenant.name} fahran" }
    # end
  end
  

  private

  def set_hospital
    @hospital = Hospital.find(params[:id])
    
  end

  def hospital_params
    params.require(:hospital).permit(:name, :location, :email, :license_no, :slug, :user_id)
  end
end
