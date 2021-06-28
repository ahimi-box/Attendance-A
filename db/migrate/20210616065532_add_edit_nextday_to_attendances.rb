class AddEditNextdayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_superior, :string
    add_column :attendances, :edit_nextday, :boolean
    add_column :attendances, :change, :boolean
    add_column :attendances, :instructor, :string
    add_column :attendances, :change_started_at, :datetime
    add_column :attendances, :change_finished_at, :datetime
  end
end
