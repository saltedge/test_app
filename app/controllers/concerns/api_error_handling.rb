module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception,           with: :handle_internal_server_error
    rescue_from Error::TestAppError, with: :handle_api_exception
  end

  private

  def handle_api_exception(error)
    hash = error.hash_with_params(params)
    render json: hash.to_json, status: error.status
  end

  def handle_internal_server_error(original_exception)
    error = Error::External::InternalServerError.new
    notify_airbrake(original_exception)

    @error_message = original_exception.message
    @error_class   = original_exception.class.to_s

    handle_api_exception(error)
  end
end
