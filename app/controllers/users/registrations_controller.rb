# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
 
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def index
  
  end

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  def create
    @hospital = Hospital.new(hospital_params)
    
    respond_to do |format|
      if @hospital.save
        # After creating the hospital, create the user
        @user = User.new(user_params)
        @user.hospital_id = @hospital.id
       
       

        if @user.save
          # Construct the subdomain
          @hospital.update(user_id:@user.id)
          host_with_subdomain = "#{@hospital.subdomain}.localhost"
          port = 3000
  
          # Construct the URL with the subdomain using URI module
          url_with_subdomain = URI::HTTP.build(
            host: host_with_subdomain,
            port: port,
            # path: new_user_session_path,  ADD THE ROUTE TO HOSPITAL DASHBOARD HERE
          ).to_s
  
          # Redirect to the sign-in page with the subdomain
          format.html { redirect_to url_with_subdomain, notice: 'User and hospital were successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          # Rollback hospital creation if user creation fails
          @hospital.destroy
          format.html { render :new, alert: 'Hospital was created, but user could not be saved.' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end
  

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender, :role ,:email ,:password,:encrypted_password])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:name, :gender, :role])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :gender,:role,:password)
  end


  def hospital_params
    # Extract hospital attributes from params
    obj_params = params.require(:user).permit(:hospital_name, :hospital_location, :hospital_email, :license_no)
    sub_domain=filter_hospital_subdomain(obj_params[:hospital_name])
    # Convert permitted params to the format expected by the Hospital model
    {
      name: obj_params[:hospital_name],
      location: obj_params[:hospital_location],
      email: obj_params[:hospital_email],
      license_no: obj_params[:license_no],
      subdomain: sub_domain
    }
  end

  def filter_hospital_subdomain(name)
    subdomain = name.gsub(/[^0-9a-z]/i, '').downcase if name.present?
    return subdomain
  end
  
end




  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end
  # 

  

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
