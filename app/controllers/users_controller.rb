class UsersController < ApplicationController
 
  before_action :authenticate_user! ,except:[:index]
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
  end

  private


  def user_params
    params.require(:user).permit(:name, :email, :gender,:role,:password)
  end



end
