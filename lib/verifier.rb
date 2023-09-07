
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
    fields = data[:fields]

    full_name     = fields[:full_name]
    citizenship   = fields[:citizenship]
    date_of_birth = fields[:date_of_birth]
    gender        = fields[:gender]        

    sql = <<-SQL
      SELECT id
      FROM  sanctionable_entities
      WHERE extra::text SIMILAR TO :full_name AND
            extra::text SIMILAR TO :citizenship AND
            extra::text SIMILAR TO :date_of_birth AND
            (gender = :gender OR gender = '' OR gender IS NULL)
    SQL

    sanctionable_entities = SanctionableEntity.find_by_sql(
      [
        sql,
        {
          full_name:     '%"full_name": '    + "\"#{full_name}\""   + '%',
          citizenship:   '%"country_code": ' + "\"#{citizenship}\"" + '%',
          date_of_birth: '%"date": '         + "\"#{date_of_birth}\""  + '%',
          gender:        gender
        }
      ]
    )

    { 
      person_details: {
        full_name:     full_name,
        citizenship:   citizenship,
        date_of_birth: date_of_birth,
        gender:        gender
      },
      detected:              sanctionable_entities.size > 0 ? true : false,
      sanctionable_entities: sanctionable_entities.as_json(only: [:id, :official_id])
    }
  end
end