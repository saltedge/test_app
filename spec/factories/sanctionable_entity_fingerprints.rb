FactoryBot.define do
  factory :sanctionable_entity_fingerprint do
    sanctionable_entity { nil }
    fingerprint { "MyString" }
  end
end
