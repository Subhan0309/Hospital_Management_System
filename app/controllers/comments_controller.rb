class CommentsController < ApplicationController
  before_action :set_user
  before_action :set_medical_record
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_comment!, only: [:edit, :update, :destroy]

  def index
    @comments = @medical_record.comments

  end

  # GET /medical_records/:medical_record_id/comments/:id
  def show
  end

  # GET /medical_records/:medical_record_id/comments/new
  def new
    @comment = @medical_record.comments.build
  end

  # POST /medical_records/:medical_record_id/comments
  def create
    @comment = @medical_record.comments.build(comment_params)
    @comment.created_by = current_user
  
    respond_to do |format|
      if @comment.save
        if current_user.role == 'patient'
          format.html { redirect_to user_medical_records_path(current_user), notice: 'Comment was successfully created.' }
        elsif current_user.role == 'doctor'
          format.html { redirect_to patients_path, notice: 'Comment was successfully created.' }
        else
          format.html { redirect_to root_path, notice: 'Comment was successfully created.' }
        end
        format.js   # Handles JS requests
      else
      
        format.js   # Handles JS requests
      end
    end
  end
  
  # GET /medical_records/:medical_record_id/comments/:id/edit
  def edit
  end

  # PATCH/PUT /medical_records/:medical_record_id/comments/:id
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to user_medical_record_comments_url(@user, @medical_record), notice: 'Comment was successfully updated.' }
        format.js   # This will render edit.js.erb
      else
        format.html { render :edit }
        format.js   # This will render edit.js.erb to handle errors
      end
    end
  end

  # DELETE /medical_records/:medical_record_id/comments/:id
  def destroy
    
    @comment.destroy
    redirect_to user_medical_record_comments_url(@user,@medical_record), notice: 'Comment was successfully destroyed.'
  end

  private

  def set_medical_record
    @medical_record = MedicalRecord.find(params[:medical_record_id])
   
  end

  def authorize_comment!
    unless @comment.created_by_id == current_user.id
      redirect_to user_medical_record_comments_path(@user,@comment.associated_with_id), alert: 'You are not authorized to perform this action.'
    end
  end

  def set_comment
    @comment = @medical_record.comments.find(params[:id])
    
  end

  def set_user
    @user=User.find(params[:user_id])
  end

  def comment_params
    params.require(:comment).permit(:description, :created_by_id, :associated_with_id, :associated_with_type)
  end
end
