require "csv"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

return unless Rails.env.development?

User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

sanctionable_entities = CSV.open("db/seeds/sanctionable_entities.csv", headers: :first_row).map(&:to_h)
sanctionable_entities.each do |entity|
  entity["extra"] = JSON.parse(entity["extra"])
  SanctionableEntity.create!(entity)
end

print("Seeds have been inserted!")