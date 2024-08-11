class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  set_current_tenant_by_subdomain(:hospital, :subdomain)

  before_action :log_current_tenant

  private

  def log_current_tenant
    Rails.logger.info "Current tenant is: #{current_tenant.inspect}" if current_tenant
    Rails.logger.info "Current user is: #{current_user.inspect}" if current_user
  end
end

