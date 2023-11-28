# frozen_string_literal: true

class ImportUnEntriesWorker
  IMPORT_URL = 'https://scsanctions.un.org/resources/xml/en/consolidated.xml'
  LIST_NAME = 'UN'

  attr_reader :data

  def perform
    load_data
    delete_un_entires
    import_data
  end

  private

  def delete_un_entires
    delete_scope = (list_name: LIST_NAME, creator_id: nil, updater_id: nil)
    SanctionableEntityFingerprint.joins(:sanctionable_entity).where(sanctionable_entity: delete_scope).delete_all
    SanctionableEntity.where(delete_scope).delete_all
  end

  def import_data
    data.xpath('//CONSOLIDATED_LIST/INDIVIDUALS/INDIVIDUAL').each { |r| create_entry(r) }
  end

  def load_data
    @data ||= Nokogiri::XML(URI.open(IMPORT_URL))
  end

  def create_entry(row)
    gender =  row.xpath('GENDER').text || ''
    entry = SanctionableEntity.new(
      list_name: LIST_NAME,
      gender: gender[0],
      official_id: row.xpath('DATAID').text
      extra: build_extra(row)
    )
    entity.fingerprints = FingerprintBuilder.for_entry(entity)
    entity.save!
  end

  def build_extra(row)
    {
      birth_datas: row.xpath('INDIVIDUAL_DATE_OF_BIRTH/DATE').map {|a| {date: a.text} },
      citizenships: row.xpath('NATIONALITY/VALUE').map {|a| {country: a.text} },
      name_aliases: row.xpath('INDIVIDUAL_ALIAS/ALIAS_NAME').map { |a| {full_name: a.text} }
    }.with_indifferent_access
  end
end
