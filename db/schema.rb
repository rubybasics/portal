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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151005203248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "activities" because of following StandardError
#   Unknown type 'activity_type' for column 'activity_type'

  create_table "activities_to_cohorts", force: true do |t|
    t.integer "activity_id"
    t.integer "cohort_id"
  end

  create_table "activities_to_instructors", force: true do |t|
    t.integer "activity_id"
    t.integer "instructor_id"
  end

  create_table "activities_to_locations", force: true do |t|
    t.integer "activity_id"
    t.integer "location_id"
  end

# Could not dump table "cohorts" because of following StandardError
#   Unknown type 'status_type' for column 'status'

  create_table "instructors", force: true do |t|
    t.string "name"
  end

  create_table "locations", force: true do |t|
    t.string  "name"
    t.integer "activity_id"
  end

end
