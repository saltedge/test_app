require 'nokogiri'
require 'json'
require 'iso_country_codes'

class RetrieveSanctionListUnJob < ApplicationJob
  def perform
    un_sanction_list = RestClient.get(Settings.sanctions_sources.un_url, headers: { accept: :xml })

    sanction_list_converted = JSON.parse(Hash.from_xml(un_sanction_list).to_json)

    sanction_list_converted['CONSOLIDATED_LIST']['INDIVIDUALS'].each do |individuals|

      individuals&.fetch(1).each do |individual|
        list_name = 'UN'
        official_id = individual&.fetch('REFERENCE_NUMBER')
        gender = individual&.fetch('GENDER', '')&.downcase
        gender = gender == 'male' ? 'M' : (gender == 'female' ? 'F' : '')
        place_of_birth = individual&.fetch('INDIVIDUAL_PLACE_OF_BIRTH', [])
        date_of_birth = individual&.fetch('INDIVIDUAL_DATE_OF_BIRTH', {})

        if place_of_birth.is_a?(Array)
          place_of_birth = place_of_birth[0]
        end

        if date_of_birth.is_a?(Array)
          date_of_birth = date_of_birth[0]
        end

        date = date_of_birth&.fetch('TYPE_OF_DATE', '') == 'EXACT' ? date_of_birth&.fetch('DATE', '') : ''
        year = date_of_birth&.fetch('TYPE_OF_DATE', '') == 'APPROXIMATELY' ? date_of_birth&.fetch('YEAR', '') : ''

        individual_name_aliases = []

        individual_name_aliases << [
          'full_name': individual&.fetch('FIRST_NAME', '') + ' ' + individual&.fetch('SECOND_NAME', '') + ' ' + individual&.fetch('THIRD_NAME', '')
        ]

        individual&.fetch('INDIVIDUAL_ALIAS') do |name_alias|
          individual_name_aliases << [
            'full_name': name_alias&.fetch('ALIAS_NAME')
          ]
        end

        country_name = place_of_birth&.fetch('COUNTRY', '')&.downcase
        country_code = ''

        # Find the country in the array
        if country_name
          country_details = IsoCountryCodes.all.find { |country| country.name.downcase == country_name }
          country_code = country_details&.alpha2 ? country_details&.alpha2 : ''
        end

        extra = {
          addresses: [],
          birth_datas: [
            {
              city: place_of_birth&.fetch('CITY', ''),
              year: year,
              date: date,
              place: "",
              zip_code: "",
              country_code: country_code,
              calendar_type: "GREGORIAN"
            }
          ],
          citizenships: [],
          name_aliases: individual_name_aliases
        }

        sanctionable_entity = SanctionableEntity.find_or_create_by(official_id: official_id)

        sanctionable_entity.list_name = list_name
        sanctionable_entity.official_id = official_id
        sanctionable_entity.gender = gender
        sanctionable_entity.additional_info = individual&.fetch('COMMENTS1')
        sanctionable_entity.extra = extra
        sanctionable_entity.save

      end
    end
  end
end