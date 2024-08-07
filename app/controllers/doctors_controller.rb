class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]

  # GET /doctors
  def index
    # @doctors=Doctor.all
    @doctors=User.all.where(hospital_id:ActsAsTenant.current_tenant , role:"doctor")

  end

  # GET /doctors/1
  def show
    
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      redirect_to doctors_path, notice: 'Doctor was successfully created.'
    else
      render :new
    end
  end
  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors
  

  # PATCH/PUT /doctors/1
  def update
    if @doctor.update(doctor_params)
      redirect_to doctors_path, notice: 'Doctor was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /doctors/1
  def destroy
    @doctor.destroy
    respond_to do |format|
      format.html { redirect_to doctors_url, notice: 'Doctor was successfully deleted.' }
      format.json { head :no_content }
     end 
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:name, :email, :hospital_id) # Add other permitted attributes here
  end
end
