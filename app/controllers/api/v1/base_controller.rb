class Api::V1::BaseController < ApplicationController
  include ApiErrorHandling

  skip_before_action :verify_authenticity_token

  def authenticate_external_app
    if request.headers["HTTP_APP_SECRET"].blank?
      raise Error::Internal::AppSecretNotReceived
    end

    if Settings.external_app.external_app_to_test_app_secret.blank?
      raise Error::Internal::MissingAppSecretSettingsKey
    end

    if Settings.external_app.external_app_to_test_app_secret != request.headers["HTTP_APP_SECRET"]
      raise Error::Internal::ExternalAppSecretInvalid
    end
  end
end
