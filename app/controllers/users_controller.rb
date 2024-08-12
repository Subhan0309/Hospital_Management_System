class UsersController < ApplicationController
before_action :authenticate_user!
  before_action :find_user, only: [:update, :edit, :show, :destroy]
  # layout 'users', only: [:index]
  def index
    # Fetch users with roles 'admin' and 'staff' belonging to the current tenant
    @users = User.all.where(role: ['admin', 'staff'])
  end

  def show
    respond_to do |format|
     
        format.html {render plain: "Hey you are at the show "}
        format.json { render json: { error: 'No hospitals found' }, status: :not_found }
     
    end
  end
  def new
    @user=User.new()
  end

  def create
   
    @user=User.new(user_params)
    @user.hospital_id=ActsAsTenant.current_tenant.id
    if @user.save
      redirect_to users_path,notice: "User (#{user_params[:role]}) was Successfully created"
    else
       # Render the new template again with errors
       render :new, alert: @user.errors.full_messages.to_sentence
    end

  end

  def edit
  end


  def update
    if @user.update(user_params)
      redirect_to users_path,notice: "User (#{user_params[:role]}) was Successfully Updated "
    else
      # If the update fails (e.g., due to validation errors), render the edit form again
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path,notice: 'User was successfully Destroyed.'
    else
      redirect_to users_path,notice: 'There is an error in deleting a user'
    end
  end

  private


  def user_params
    params.require(:user).permit(:name, :email, :gender,:role,:password)
  end
  def find_user
    @user = User.find(params[:id])
    
  end



end
