class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|
      t.string :month_superior
      t.date :one_month
      t.string :instructor_confirmation
      t.boolean :checkbox
      t.integer :applicant_user_id
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
