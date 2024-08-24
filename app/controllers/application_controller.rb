class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  set_current_tenant_by_subdomain(:hospital, :subdomain)

  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :forbidden
  rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
  rescue_from StandardError, with: :internal_server_error
  rescue_from CanCan::AccessDenied , with: :forbidden


  private

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
  def not_found
    redirect_to '/404'
  end

  def forbidden
    redirect_to '/403'
  end

  def unprocessable_entity
    redirect_to '/422'
  end

  def internal_server_error
    redirect_to '/500'
  end
end

