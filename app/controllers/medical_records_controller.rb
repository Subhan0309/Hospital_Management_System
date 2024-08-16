class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_medical_record, only: [:show, :edit, :update, :destroy]
  
  
  def index
    if current_user.doctor?
       @medical_records = @user.medical_records.where(doctor_id: current_user.id)
    else
      @medical_records = @user.medical_records
    end
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
      render :new, alert: @medical_record.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    @medical_record = MedicalRecord.find(params[:id])
    
    if params[:medical_record] && params[:medical_record][:attachments]
      # Append new attachments to existing ones
      @medical_record.attachments.attach(params[:medical_record][:attachments])
    end

    if @medical_record.update(medical_record_params.except(:attachments))
      redirect_to [@medical_record.user, @medical_record], notice: 'Attachment added successfully'
    else
      redirect_to [@medical_record.user, @medical_record], alert: 'Attachment not added'
    end
  end

  def destroy
    @medical_record.destroy
    redirect_to medical_records_url, notice: 'Medical record was successfully destroyed.'
  end
  def attach_files
    binding.pry
    @medical_record = MedicalRecord.find(params[:id])
    if params[:attachments]
      params[:attachments].each do |attachment|
        @medical_record.attachments.attach(attachment)
      end
      redirect_to @medical_record, notice: 'Attachments were successfully added.'
    else
      redirect_to @medical_record, alert: 'No attachments were selected.'
    end
  end



  def delete_attachment
    @medical_record = MedicalRecord.find(params[:medical_record_id])
    attachment = @medical_record.attachments.find(params[:attachment_id])
    attachment.purge
    redirect_to user_medical_record_path(params[:user_id], @medical_record), notice: 'Attachment was successfully deleted.'
  end
  

  private
  def set_user
    @user = Patient.find(params[:user_id])
   end
  def set_medical_record
    @medical_record = @user.medical_records.find(params[:id])
  end
  def medical_record_params
    params.require(:medical_record).permit(:date, :details, :patient_id, :doctor_id, attachments: [])
  end

end
