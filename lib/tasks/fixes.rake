# frozen_string_literal: true

namespace :fixes do
  desc 'Build fingerprints'
  task build_fingerprints: :environment do
    SanctionableEntity.find_each do |sanctionable_entity|
      sanctionable_entity.fingerprints = FingerprintBuilder.for_entry(sanctionable_entity)
      sanctionable_entity.save!
    end
  end
end
