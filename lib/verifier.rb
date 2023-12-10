
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
    fields_to_check = data[:fields_to_check]
    person = data[:fields]

    query_params = Hash.new(0)
    query_where = Array.new
    person_fields_map = {
      citizenship: 'country_code',
      date_of_birth: 'date',
    }

    fields_to_check.each do |field|
      if field == 'gender'
        query_params[field] = field
        query_where << "(gender = :gender OR gender = '' OR gender IS NULL)"
      end
      if field == 'full_name'
        query_params[field] = '%"'+person_fields_map[field] unless field +'": '    + '"'+person[field]+'"' + '%'
        query_where << "extra::text ILIKE :#{field}"
      else
        query_params[field] = '%"'+person_fields_map[field] unless field +'": '    + '"'+person[field]+'"' + '%'
        query_where << "extra::text SIMILAR TO :#{field}"
      end
    end

    sql = <<-SQL
      SELECT id
      FROM  sanctionable_entities
      WHERE #{query_where.join(' AND ')}
    SQL

    sanctionable_entities = SanctionableEntity.find_by_sql(
      [
        sql,
        {
          full_name:     '%"full_name": '    + "\"#{person['full_name']}\""   + '%',
          citizenship:   '%"country_code": ' + "\"#{person['citizenship']}\"" + '%',
          date_of_birth: '%"date": '         + "\"#{person['date_of_birth']}\""  + '%',
          gender:        person['gender']
        }
      ]
    )

    { 
      person_details:        person,
      detected:              sanctionable_entities.size > 0 ? true : false,
      sanctionable_entities: sanctionable_entities.as_json(only: [:id, :official_id])
    }
  end
end