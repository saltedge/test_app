FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test_user#{n * 2}@test_app.com"
    end
    password              { "password" }
    password_confirmation { "password" }
  end

  factory :sanctionable_entity do
    list_name { "EU" }
    sequence :official_id do |n|
      "EU.#{n * 2}.112233"
    end
    gender { "M" }
    additional_info { "some additional info" }
    extra {
      {
        addresses:    [{ city: "city name", region: "region", street: "street", country_code: "MD" }],
        birth_datas:  [{ city: "city name", date: "1999-12-31", place: "place name", country_code: "MD" }],
        citizenships: [{ country_code: "MD" }],
        name_aliases: [
          { full_name: "john richard doe" },
          { full_name: "johny doe"}
        ]
      }
    }

    trait :with_fingerprints do
      after :create do |entry, _|
        entry.fingerprints = FingerprintBuilder.for_entry(entry)
      end
    end
  end
end
