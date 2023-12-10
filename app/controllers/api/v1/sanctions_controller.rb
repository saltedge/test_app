class Api::V1::SanctionsController < Api::V1::BaseController
  before_action :authenticate_external_app

  REQUIRED_FIELDS = %w(list_of_persons meta)

  def check_persons
    check_required_fields

    render json: {
      data: {
        results_of_verification: Verifier.new(data).run,
        client_id: data["meta"]["client_id"].to_s
      }
    }      
  end

  private

  def check_required_fields
    missing_fields = REQUIRED_FIELDS.select { |field| data[field].blank? }
    raise Error::Internal::MissingRequiredFields.new(missing_fields) unless missing_fields.empty?
    raise Error::Internal::ListOfPersonsLimitExceeded.new if data[:list_of_persons].size > 100
    check_person_fields(data[:list_of_persons])
  end

  def check_person_fields (list_of_persons)
    list_of_persons.each do |person|
      fields_to_check = person[:fields_to_check]

      if fields_to_check.empty?
        raise Error::Internal::MissingRequiredFields.new
      end

      if (check_include_only(fields_to_check, ["full_name"])) ||
        check_include_only(fields_to_check, ["full_name", "date_of_birth"]) ||
        check_include_only(fields_to_check, ["full_name", "date_of_birth", "citizenship"]) ||
        check_include_only(fields_to_check, ["full_name", "date_of_birth", "citizenship", "gender"])
        raise Error::Internal::MissingRequiredFields.new(["full_name", "date_of_birth", "citizenship", "gender"])
      end
    end
  end

  def check_include_only(fields_to_check, required_fields)
    if fields_to_check.size != required_fields.size
      return false
    end

    required_fields.each do |field|
      if fields_to_check.include? field
        return false
      end
    end

    return true
  end

  def data
    @data ||= params.to_unsafe_h[:data]
  end
end