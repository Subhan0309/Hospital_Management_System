class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user ,except: :all_comments
  before_action :set_commentable, only: [:index, :new, :create, :destroy, :edit, :update]
   before_action :set_medical_record,except: :all_comments
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_comment!, only: [:edit, :update, :destroy]
  before_action :authorize_access ,only: :all_comments
  def index
    @comments = @commentable.comments

  end

  # GET /medical_records/:medical_record_id/comments/:id
  def show
  end

  # GET /medical_records/:medical_record_id/comments/new
  def new
    @comment = @commentable.comments.build
  end

  # POST /medical_records/:medical_record_id/comments
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.created_by = current_user
    respond_to do |format|
      if @comment.save
       CommentMailer.comment_notification(@commentable, @comment).deliver_now
        format.js
        if @commentable.is_a?(MedicalRecord)
          format.html { redirect_to user_medical_record_comments_url(@user, @medical_record), notice: 'Comment was successfully created.' }
        else
        case current_user.role
        when "patient"
          format.html { redirect_to patient_comments_path(current_user), notice: 'Comment was successfully created.' }
        when "doctor"
          format.html { redirect_to doctor_comments_path(current_user), notice: 'Comment was successfully created.' }
        when "admin", "staff"
          format.html { redirect_to user_comments_path(current_user), notice: 'Comment was successfully created.' }
        when "owner"
          format.html { redirect_to all_comments_path, notice: 'Comment was successfully created.' }
        end
      end
      else
        flash[:alert] = 'Failed to add comment. Please try again.'
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
      else
        format.html { render :edit }
      end
      format.js   # This will render edit.js.erb to handle errors
    end
  end

  # DELETE /medical_records/:medical_record_id/comments/:id
  def destroy
    @comment.destroy
    if current_user.patient?
      if @commentable.is_a?(MedicalRecord) && @commentable.id.to_s == params[:medical_record_id] 
        redirect_to user_medical_record_comments_url(@user,@medical_record), notice: 'Comment was successfully destroyed.'            
      else 
        redirect_to patient_comments_url(@user), notice: 'Comment was successfully destroyed.'          
      end
   elsif current_user.doctor? 
       if @commentable.is_a?(MedicalRecord) && @commentable.id.to_s == params[:medical_record_id] 
          redirect_to user_medical_record_comments_url(@user,@medical_record), notice: 'Comment was successfully destroyed.'            
       else 
         redirect_to doctor_comments_url(@user), notice: 'Comment was successfully destroyed.'            
        end
   elsif current_user.admin? || current_user.staff? || current_user.owner?
     if @commentable.is_a?(MedicalRecord) && @commentable.id.to_s == params[:medical_record_id] 
      redirect_to user_medical_record_comments_url(@user,@medical_record), notice: 'Comment was successfully destroyed.'
     else
      redirect_to user_comments_url(@user), notice: 'Comment was successfully destroyed.'
     end
     end
  end

  def all_comments
    @comments = Comment.includes(:created_by, :associated_with).paginate(page: params[:page], per_page: 10)
  end
  private

  def set_medical_record
    @medical_record = if params[:medical_record_id]
                       MedicalRecord.find(params[:medical_record_id])
                      end
   
  end

  def authorize_comment!
    if @commentable.is_a?(MedicalRecord) && @commentable.id.to_s == params[:medical_record_id] 
    unless @comment.created_by_id == current_user.id
      redirect_to user_medical_record_comments_path(@user,@comment.associated_with_id), alert: 'You are not authorized to perform this action.'
    end
  end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def set_user
  
    @user = if params[:patient_id]
              Patient.find(params[:patient_id])
            elsif params[:doctor_id]
              Doctor.find(params[:doctor_id])
            elsif params[:user_id]
              User.find(params[:user_id])
            end
  
  end
  def set_commentable
    @commentable = if params[:medical_record_id]
                     MedicalRecord.find(params[:medical_record_id])
                   elsif params[:patient_id]
                     Patient.find(params[:patient_id])
                   elsif params[:doctor_id]
                     Doctor.find(params[:doctor_id])
                   elsif params[:user_id]
                     User.find(params[:user_id])
                   end
  end
  def comment_params
    params.require(:comment).permit(:description, :created_by_id, :associated_with_id, :associated_with_type)
  end
  def authorize_access
    authorize! :access, :all_comments
  end
end
