# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091201173838) do

  create_table "assets", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["attachable_id"], :name => "index_assets_on_attachable_id"

  create_table "assignments", :force => true do |t|
    t.integer  "assignee_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "workmate_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["user_id"], :name => "index_collaborations_on_user_id"
  add_index "collaborations", ["workmate_id"], :name => "index_collaborations_on_workmate_id"

  create_table "comments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "author_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["message"], :name => "index_comments_on_message"
  add_index "comments", ["task_id"], :name => "index_comments_on_task_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hashtags", :force => true do |t|
    t.integer  "project_id"
    t.integer  "tasks_count"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtags", ["project_id"], :name => "index_hashtags_on_project_id"

  create_table "hashtagships", :force => true do |t|
    t.integer  "hashtag_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtagships", ["hashtag_id"], :name => "index_hashtagships_on_hashtag_id"
  add_index "hashtagships", ["task_id"], :name => "index_hashtagships_on_task_id"

  create_table "participations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["participant_id"], :name => "index_participations_on_participant_id"
  add_index "participations", ["project_id"], :name => "index_participations_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["creator_id"], :name => "index_projects_on_creator_id"

  create_table "readerships", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "readerships", ["task_id"], :name => "index_readerships_on_task_id"
  add_index "readerships", ["user_id"], :name => "index_readerships_on_user_id"

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "author_id"
    t.string   "message"
    t.string   "status"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["author_id"], :name => "index_tasks_on_author_id"
  add_index "tasks", ["message"], :name => "index_tasks_on_message"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false, :null => false
  end

end
