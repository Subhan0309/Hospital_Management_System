class ErrorsController < ApplicationController
  # Generic error page
  def internal_server_error
    render status: :internal_server_error
  end

  # 404 Not Found
  def not_found
    render status: :not_found
  end

  # 403 Forbidden
  def forbidden
    render status: :forbidden
  end

  # 422 Unprocessable Entity
  def unprocessable_entity
    render status: :unprocessable_entity
  end

  # Custom method to handle other errors if necessary
  def handle_exception
    render status: :bad_request
  end
end
