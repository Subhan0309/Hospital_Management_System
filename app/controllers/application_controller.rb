class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  set_current_tenant_by_subdomain(:hospital, :subdomain)

  before_action :log_current_tenant
  before_action :set_locale

  
  
  def routing_error
    raise ActionController::RoutingError, 'Page not found'
  end

  # rescue_from CanCan::AccessDenied do
  #   respond_to do |format|
  #     format.html { redirect_to hospital_dashboard_path, alert: 'You are not authorized to access this page.' }
  #     format.json { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
  #     format.js   { render json: { error: 'You are not authorized to access this page.' }, status: :forbidden }
  #   end
  # end
  # Handle Routing Errors
  # rescue_from ActionController::RoutingError do
  #   respond_to do |format|
  #     format.html { redirect_to hospital_dashboard_path, alert: 'Page not found.' }
  #     format.json { render json: { error: 'Page not found.' }, status: :not_found }
  #     format.js   { render json: { error: 'Page not found.' }, status: :not_found }
  #     format.any  { render plain: 'Page not found.', status: :not_found }
  #   end
  # end
  # Handle Record Not Found
  # rescue_from ActiveRecord::RecordNotFound do
  #   respond_to do |format|
  #     format.html { redirect_to hospital_dashboard_path, alert: 'The record you were looking for could not be found.' }
  #     format.json { render json: { error: 'The record you were looking for could not be found.' }, status: :not_found }
  #     format.js   { render json: { error: 'The record you were looking for could not be found.' }, status: :not_found }
  #   end
  # end

  private

  def log_current_tenant
    Rails.logger.info "Current tenant is: #{current_tenant.inspect}" if current_tenant
    Rails.logger.info "Current user is: #{current_user.inspect}" if current_user
  end


  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale.to_sym :
      nil
  end
end

