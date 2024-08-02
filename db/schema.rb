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

ActiveRecord::Schema[7.1].define(version: 2024_07_31_175547) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hands", force: :cascade do |t|
    t.bigint "shoe_id", null: false
    t.text "dealer_cards"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_spot_id"
    t.index ["current_spot_id"], name: "index_hands_on_current_spot_id"
    t.index ["shoe_id"], name: "index_hands_on_shoe_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "decks"
    t.integer "penetration"
    t.boolean "early_sur", default: false
    t.boolean "late_sur", default: false
    t.boolean "stand_17", default: false
    t.boolean "double_any", default: true
    t.integer "num_spots"
    t.boolean "six_five", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shoes", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.text "cards"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shuffle_hash"
    t.string "client_seed"
    t.integer "penetration_index"
    t.integer "current_card_index", default: 0
    t.boolean "active", default: true
    t.index ["session_id"], name: "index_shoes_on_session_id"
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hand_id"
    t.text "player_cards"
    t.integer "wager"
    t.boolean "split"
    t.boolean "double"
    t.integer "result"
    t.integer "profit", default: 0
    t.boolean "insurance"
    t.integer "spot_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "session_id", null: false
    t.integer "insurance_result"
    t.bigint "parent_spot_id"
    t.index ["hand_id"], name: "index_spots_on_hand_id"
    t.index ["parent_spot_id"], name: "index_spots_on_parent_spot_id"
    t.index ["session_id"], name: "index_spots_on_session_id"
    t.index ["split"], name: "index_spots_on_split"
    t.index ["spot_number"], name: "index_spots_on_spot_number"
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "hands", "shoes"
  add_foreign_key "hands", "spots", column: "current_spot_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "shoes", "sessions"
  add_foreign_key "spots", "hands"
  add_foreign_key "spots", "sessions"
  add_foreign_key "spots", "spots", column: "parent_spot_id"
  add_foreign_key "spots", "users"
end
