class Api::V1::SanctionsController < Api::V1::BaseController
  before_action :authenticate_external_app

  REQUIRED_FIELDS = %w(list_of_persons meta)

  def check_persons
    check_required_fields
    render json: {
      results_of_verification: Verifier.new(data).run,
      client_id: data["meta"]["client_id"].to_s
    }
  end

  private

  def check_required_fields
    missing_fields = REQUIRED_FIELDS.select { |field| data[field].blank? }
    raise Error::Internal::MissingRequiredFields.new(missing_fields) unless missing_fields.empty?
    if data[:list_of_persons].size > Settings.api.limits.max_list_size
      raise Error::Internal::ListOfPersonsLimitExceeded.new(max_size: Settings.api.limits.max_list_size)
    end
  end

  def data
    @data ||= params.to_unsafe_h[:data]
  end
end
