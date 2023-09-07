class SanctionableEntity < ActiveRecord::Base
  validates :list_name, presence: true
  validates :official_id, presence: true
  validates :extra, presence: true
end