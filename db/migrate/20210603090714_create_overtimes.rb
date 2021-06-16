class CreateOvertimes < ActiveRecord::Migration[5.1]
  def change
    create_table :overtimes do |t|
      t.integer :applicant_user_id
      t.date :overtime
      t.date :scheduled_end_time
      t.string :business_processing_content
      t.boolean :nextday
      t.string :superior
      t.string :instructor_confirmation
      t.datetime :before_started_at
      t.datetime :before_finished_at
      t.datetime :after_started_at
      t.datetime :after_finished_at
      t.date :change_day
      t.string :who_consent
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
