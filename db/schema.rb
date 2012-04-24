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

ActiveRecord::Schema.define(:version => 20120424145359) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "content"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "home_id"
    t.integer  "away_id"
    t.boolean  "final"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "group_id"
    t.datetime "kickoff"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "cup_game"
    t.integer  "cup_home_score"
    t.integer  "cup_away_score"
    t.boolean  "cup_final"
    t.string   "cup_name"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "country"
    t.integer  "group_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "abbreviation"
    t.string   "flag_extension"
    t.boolean  "eliminated"
    t.boolean  "placeholder"
  end

  create_table "tips", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "points"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "admin"
    t.boolean  "cleared"
    t.integer  "points"
  end

  create_table "winners_tips", :force => true do |t|
    t.integer  "user_id"
    t.integer  "winning_team"
    t.integer  "runner_up"
    t.string   "goal_scorer"
    t.string   "first_swedish_scorer"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end
