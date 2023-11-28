
class Verifier
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def run
    params[:list_of_persons].map { |person_details| check_person(person_details) }
  end

  private

  def check_person(data)
    lookup_params = data[:fields].slice(*data[:fields_to_check]).symbolize_keys

    fingerprints = [
      FingerprintBuilder.fingerprint(**lookup_params),
      lookup_params[:gender] ? FingerprintBuilder.fingerprint(**lookup_params, gender: '') : nil
    ].compact

    results = SanctionableEntityFingerprint.by_fingerprints(fingerprints).select('sanctionable_entity_id as id, official_id').to_a

    {
      person_details: lookup_params,
      detected:              results.size > 0 ? true : false,
      sanctionable_entities: results.as_json(only: [:id, :official_id])
    }
  end
end
