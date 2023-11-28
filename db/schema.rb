# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_11_23_201448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sanctionable_entities", force: :cascade do |t|
    t.string "list_name", null: false
    t.string "official_id"
    t.string "gender"
    t.string "additional_info"
    t.jsonb "extra", default: {}, null: false
    t.integer "creator_id"
    t.integer "updater_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["extra"], name: "index_sanctionable_entities_on_extra"
    t.index ["official_id", "list_name"], name: "index_sanctionable_entities_on_official_id_and_list_name", unique: true
  end

  create_table "sanctionable_entity_fingerprints", force: :cascade do |t|
    t.bigint "sanctionable_entity_id", null: false
    t.string "official_id"
    t.string "fingerprint"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fingerprint"], name: "index_sanctionable_entity_fingerprints_on_fingerprint"
    t.index ["sanctionable_entity_id"], name: "fingerprints_on_sanctionable_entity_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "sanctionable_entity_fingerprints", "sanctionable_entities"
end
