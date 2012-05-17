# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120517045450) do

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "assignee_id"
    t.string   "subject"
    t.text     "description"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "priority"
  end

  add_index "issues", ["assignee_id"], :name => "index_issues_on_assignee_id"
  add_index "issues", ["priority"], :name => "index_issues_on_priority"
  add_index "issues", ["project_id"], :name => "index_issues_on_project_id"
  add_index "issues", ["user_id"], :name => "index_issues_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "team_memberships", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "owner"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "team_memberships", ["owner"], :name => "index_team_memberships_on_owner"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
