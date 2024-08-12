class LandingPagesController < ApplicationController
  before_action :redirect_if_subdomain_present
  def index
    # Render the global landing page
  end

  private

  def redirect_if_subdomain_present
    if request.subdomain.present? && valid_subdomain?(request.subdomain) && current_user
      # Rails.logger.info "Current user is: #{current_user.inspect}"
      redirect_to hospital_dashboard_path
    end
  end

  def valid_subdomain?(subdomain)
    # Assuming slug is used as the subdomain
    Hospital.exists?(subdomain: subdomain)
  end
  def index
    
  end
end
