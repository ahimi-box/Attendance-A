class AddSuperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :superior, :boolean
    add_column :users, :work_start_time, :datetime, default: Time.current.change(hour: 8, min: 0, sec: 0)
    add_column :users, :work_finish_time, :datetime, default: Time.current.change(hour: 17, min: 0, sec: 0)   
  end
end
