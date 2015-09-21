require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'development.sqlite3'
)

class WundergroundMigration < ActiveRecord::Migration
  def change
    create_table "assignment_grades", force: true do |t|
      t.integer  "assignment_id"
      t.integer  "course_student_id"
      t.float    "final_grade"
      t.datetime "submitted_at"
      t.text     "comments"
      t.timestamps
    end
  end
end
