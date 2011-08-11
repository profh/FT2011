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

ActiveRecord::Schema.define(:version => 20110806191052) do

  create_table "announcements", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "title"
    t.date     "expires_on"
    t.integer  "organization_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "late",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoint_organizations", :force => true do |t|
    t.integer  "checkpoint_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoint_users", :force => true do |t|
    t.integer  "checkpoint_id"
    t.integer  "user_id"
    t.decimal  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoints", :force => true do |t|
    t.string   "name"
    t.date     "due_on"
    t.boolean  "distributed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "street"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "relation"
    t.integer  "category"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_measurements", :force => true do |t|
    t.integer  "event_id"
    t.integer  "measurement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_organizations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "location_id"
    t.decimal  "cost"
    t.integer  "max_participants"
    t.boolean  "permission_required"
    t.integer  "event_type_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "id_cards", :force => true do |t|
    t.integer  "user_id"
    t.string   "bar_code"
    t.datetime "assigned_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "lat"
    t.float    "lon"
    t.boolean  "active",      :default => true
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_categories", :force => true do |t|
    t.string   "title"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",                  :default => true
    t.integer  "measurement_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_users", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "head"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.boolean  "active",               :default => true
    t.integer  "organization_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_options", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.integer  "measurement_id"
    t.integer  "question_type"
    t.integer  "completion_score"
    t.boolean  "active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "authority_id"
    t.integer  "id_card_id"
    t.decimal  "amount_paid"
    t.boolean  "permission_form_received"
    t.date     "deregistration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "response_options", :force => true do |t|
    t.integer  "response_id"
    t.integer  "question_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.text     "response_value"
    t.integer  "checkpoint_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshots", :force => true do |t|
    t.integer  "measurement_category_id"
    t.integer  "checkpoint_id"
    t.integer  "user_id"
    t.float    "percent_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "suffix"
    t.boolean  "active",           :default => true
    t.integer  "level"
    t.string   "gender"
    t.string   "race"
    t.date     "birthday"
    t.integer  "membership_level"
    t.string   "street"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
