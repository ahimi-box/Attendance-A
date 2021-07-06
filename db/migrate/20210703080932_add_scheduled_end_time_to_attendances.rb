class AddScheduledEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_end_time, :datetime
    add_column :attendances, :over_day, :date
    add_column :attendances, :over_nextday, :boolean
    add_column :attendances, :over_content, :string
    add_column :attendances, :over_superior, :string
    add_column :attendances, :over_work_time, :string
    add_column :attendances, :over_instructor, :string
    add_column :attendances, :overtime_change, :boolean
    end
end
