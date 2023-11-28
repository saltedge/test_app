class SanctionableEntityFingerprint < ApplicationRecord
  belongs_to :sanctionable_entity

  scope :by_fingerprints, ->(fingerprints) { fingerprints.map { |f| by_fingerprint(f) }.reduce(&:or) }
  scope :by_fingerprint, ->(fingerprint) { where("starts_with(fingerprint, ?)", fingerprint) }
end
