class CreateSanctionableEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :sanctionable_entities do |t|
      t.string :list_name,          null: false
      t.string :official_id
      t.string :gender
      t.string :additional_info
      t.jsonb "extra", default: {}, null: false
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps null: false
    end

    add_index :sanctionable_entities, [:official_id, :list_name], unique: true
    add_index :sanctionable_entities, :extra
  end
end
