class UsersController < ApplicationController
  before_action :authenticate_user!
  
  
  def index 
    #if current_user role is owner 
    #WE WILL SHOW OWNER DASHBOARD HERE
    #
    #similarly for other roles
    #
    #

   # binding.pry
  
  #  if current_user.role == "owner" 
  #   respond_to do |format|
     
  #     format.html { redirect_to user_path }
  #     format.json { render plain: "subhan"  }
      
  #   end
  # else
  #   respond_to do |format|
     
  #     format.html { render plain:"you are at the dashboard of other Users " }
  #     format.json { render plain: "subhan"  }
      
  #   end
  # end
  end

  def new
   
  end
  


 
end
