class SanctionableEntity < ActiveRecord::Base
  validates :list_name, presence: true
  validates :official_id, presence: true
  validates :extra, presence: true

  has_many :fingerprints, class_name: 'SanctionableEntityFingerprint', dependent: :delete_all
end
