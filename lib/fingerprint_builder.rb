# frozen_string_literal: true

module FingerprintBuilder
  def self.for_entry(entry)
    names = (entry.extra['name_aliases'] || []).map { |d| d['full_name'].presence }.uniq
    return [] if names.empty?

    birth_dates = entry.extra['birth_datas'].map { |d| d['date'].presence }.uniq.presence || ['']
    citizenship = entry.extra['citizenships'].map { |d| d['country_code'].presence }.uniq.presence || ['']
    gender = [entry.gender || '']

    names.product(birth_dates, citizenship, gender).map do |data|
      SanctionableEntityFingerprint.new(
        official_id: entry.official_id,
        fingerprint: fingerprint(
          full_name: data[0],
          date_of_birth: data[1],
          citizenship: data[2],
          gender: data[3]
        )
      )
    end
  end

  def self.fingerprint(**params)
    data = [
      params[:full_name].split.sort.join(' '),
      params[:date_of_birth],
      params[:citizenship],
    ].compact
    data << params[:gender] << '' if params[:gender]

    data.join('|')
  end
end
