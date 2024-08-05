class UsersController < ApplicationController
  before_action :authenticate_user!
  
  
  def index 
    #if current_user role is owner 
    #WE WILL SHOW OWNER DASHBOARD HERE
    #
    #similarly for other roles
    #
    #
  
    respond_to do |format|
     
      format.html { 
      # For example, redirect to the root path
      render plain:"Farhan"
   
       }
      format.json { render plain: "subhan"  }
      
    end

  end

  def new
   
  end
  


 
end
