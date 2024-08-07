class MedicalRecordsController < ApplicationController
  before_action :set_medical_record, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    if current_user.doctor
      @medical_records = current_user.doctor_medical_records
    elsif current_user.patient
      @medical_records = current_user.patient_medical_records
    else
      @medical_records = MedicalRecord.all
    end
  end

  def show
  end

  def new
    @medical_record = MedicalRecord.new
  end

  def create
    @medical_record = MedicalRecord.new(medical_record_params)
    if @medical_record.save
      redirect_to @medical_record, notice: 'Medical record was successfully created.'
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

  def set_medical_record
    @medical_record = MedicalRecord.find(params[:id])
  end

  def medical_record_params
    params.require(:medical_record).permit(:date, :patient_id, :doctor_id, :details)
  end
end
