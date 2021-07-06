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

ActiveRecord::Schema.define(version: 20210703080932) do

  create_table "approvals", force: :cascade do |t|
    t.string "month_superior"
    t.date "one_month"
    t.string "instructor_confirmation"
    t.boolean "checkbox"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_approvals_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "edit_superior"
    t.boolean "edit_nextday"
    t.boolean "change"
    t.string "instructor"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.datetime "over_end_time"
    t.date "over_day"
    t.boolean "over_nextday"
    t.string "over_content"
    t.string "over_superior"
    t.string "over_work_time"
    t.string "over_instructor"
    t.boolean "overtime_change"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "offices", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "category"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_offices_on_user_id"
  end

  create_table "overtimes", force: :cascade do |t|
    t.integer "applicant_user_id"
    t.date "overtime"
    t.datetime "scheduled_end_time"
    t.datetime "over_work_time"
    t.string "over_content"
    t.boolean "over_nextday"
    t.string "over_superior"
    t.string "over_instructor"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.date "overtime_change"
    t.string "who_consent"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_overtimes_on_attendance_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "basic_time", default: "2021-07-06 08:00:00"
    t.datetime "work_time", default: "2021-07-06 08:00:00"
    t.string "department"
    t.boolean "admin"
    t.boolean "superior"
    t.datetime "designated_work_start_time", default: "2021-07-06 08:00:00"
    t.datetime "designated_work_end_time", default: "2021-07-06 17:00:00"
    t.datetime "basic_work_time", default: "2021-07-06 08:00:00"
    t.string "affiliation"
    t.integer "employee_number"
    t.integer "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
