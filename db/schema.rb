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

ActiveRecord::Schema[8.0].define(version: 2025_01_12_042823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "board_users", force: :cascade do |t|
    t.bigint("user_id", null: false)
    t.bigint("board_id", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.integer("position")
    t.index(["board_id"], name: "index_board_users_on_board_id")
    t.index(["user_id"], name: "index_board_users_on_user_id")
  end

  create_table "boards", force: :cascade do |t|
    t.string("title", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "invites", force: :cascade do |t|
    t.bigint("user_id", null: false)
    t.bigint("board_id", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.string("email_address")
    t.index(["board_id"], name: "index_invites_on_board_id")
    t.index(["user_id"], name: "index_invites_on_user_id")
  end

  create_table "lanes", force: :cascade do |t|
    t.bigint("board_id", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.string("name", null: false)
    t.integer("position", null: false)
    t.index(["board_id"], name: "index_lanes_on_board_id")
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint("user_id", null: false)
    t.string("ip_address")
    t.string("user_agent")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["user_id"], name: "index_sessions_on_user_id")
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint("lane_id", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.string("title", null: false)
    t.text("description")
    t.integer("position", default: 0, null: false)
    t.index(["lane_id"], name: "index_tasks_on_lane_id")
  end

  create_table "users", force: :cascade do |t|
    t.string("email_address", null: false)
    t.string("password_digest", null: false)
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
    t.index(["email_address"], name: "index_users_on_email_address", unique: true)
  end

  add_foreign_key "board_users", "boards"
  add_foreign_key "board_users", "users"
  add_foreign_key "invites", "boards"
  add_foreign_key "invites", "users"
  add_foreign_key "lanes", "boards"
  add_foreign_key "sessions", "users"
  add_foreign_key "tasks", "lanes"
end
