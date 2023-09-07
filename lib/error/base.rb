module Error
  class TestAppError < StandardError
    PARAMS_IGNORE ||= %w(format action controller route error).freeze

    def initialize(message=I18n.t("errors.messages.#{self.class.name.demodulize}"))
      super
    end

    def hash_with_params(params={})
      {
        error_class: self.class.name.demodulize,
        message:     message,
        request:     cleanup_params(params),
        status:      status
      }
    end

    def status; :internal_server_error end

  private

    def cleanup_params(params)
      params.reject { |key, value| PARAMS_IGNORE.include?(key) }
    end
  end

  class Invalid < TestAppError
    def status; :not_acceptable end
  end

  class NotFound < TestAppError
    def status; :not_found end
  end

  class ServerError < TestAppError
    def status; :internal_server_error end
  end

  class BadRequest < TestAppError
    def status; :bad_request end
  end

  class AccessError < TestAppError
    def status; :unauthorized end
  end
end
