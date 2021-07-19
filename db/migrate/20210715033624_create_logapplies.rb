class CreateLogapplies < ActiveRecord::Migration[5.1]
  def change
    create_table :logapplies do |t|
      t.date :log_worked_on
      t.datetime :before_started_at
      t.datetime :before_finished_at
      t.datetime :after_started_at
      t.datetime :after_finished_at
      t.date :change_day
      t.string :superior
      t.string :instructor
      t.integer :applicant_user_id
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
