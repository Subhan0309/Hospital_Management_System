class MedicalRecordsController < ApplicationController
  before_action :set_user
  before_action :set_medical_record, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @medical_records = @user.medical_records
  end

  def show
   @medical_record
  end

  def new
    @medical_record = @user.medical_records.new
  end

  def create
  
    @medical_record = @user.medical_records.new(medical_record_params)
    @medical_record.doctor_id=current_user.id
  
    if @medical_record.save
     
      redirect_to user_medical_records_path(@user), notice: 'Medical record was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @medical_record.update(medical_record_params)
      redirect_to @medical_record, notice: 'Medical record was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @medical_record.destroy
    redirect_to medical_records_url, notice: 'Medical record was successfully destroyed.'
  end

  private
  def set_user
    @user = Patient.find(params[:user_id])
   end
  def set_medical_record

      @medical_record = @user.medical_records.find(params[:id])
     
  end

 
  def medical_record_params
    params.require(:medical_record).permit(:date, :patient_id, :doctor_id, :details)
  end
end
