class HospitalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospital, only: [:update, :edit, :show, :destroy]
  def index
    if current_user.role == "owner"
      @hospitals = Hospital.where({user_id:current_user.id})
     # binding.pry
      respond_to do |format|
        format.html { render :index } # Assuming you have an index.html.erb view
        format.json { render json: @hospitals }
      end
    else
      render plain: "No Hospitals for this User + #{current_user.role}"
    end
  end
  

  def show
    @hospital = Hospital.find(params[:id])
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
      redirect_to hospitals_path,notice: 'There is an error in deleting a user'
    end
  end


  private

  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  def hospital_params
    params.require(:hospital).permit(:name, :location, :email, :license_no, :slug, :user_id)
  end
end
