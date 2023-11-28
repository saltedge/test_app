class CreateSanctionableEntityFingerprints < ActiveRecord::Migration[6.1]
  def change
    create_table :sanctionable_entity_fingerprints do |t|
      t.references :sanctionable_entity, null: false, foreign_key: true, index: {name: 'fingerprints_on_sanctionable_entity_id'}
      t.string :official_id
      t.string :fingerprint, index: true

      t.timestamps
    end
  end
end
