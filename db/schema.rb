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

ActiveRecord::Schema.define(version: 2021_03_15_171105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "repositories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "github_id", null: false
    t.string "node_id", null: false
    t.string "full_name"
    t.boolean "private"
    t.string "description"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.string "topics", default: [], array: true
    t.uuid "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_id"], name: "index_repositories_on_github_id", unique: true
    t.index ["name"], name: "index_repositories_on_name"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "github_id", null: false
    t.string "email"
    t.string "type"
    t.integer "public_repos"
    t.integer "total_private_repos"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
