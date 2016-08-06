# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160806115512) do

  create_table "assignees", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_path"
  end

  create_table "boards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string   "name"
    t.integer  "min"
    t.integer  "max"
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
    t.index ["board_id"], name: "index_columns_on_board_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.string   "title"
    t.date     "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "namespace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "link"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "milestone_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.string   "link"
    t.integer  "project_id"
    t.string   "state"
    t.text     "labels"
    t.date     "due_date"
    t.integer  "position"
    t.integer  "column_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "gitlab_id"
    t.string   "gitlab_internal_id"
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["column_id"], name: "index_tasks_on_column_id"
    t.index ["milestone_id"], name: "index_tasks_on_milestone_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

end
