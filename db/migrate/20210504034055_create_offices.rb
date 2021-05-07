class CreateOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :offices do |t|
      t.integer :number
      t.string :name
      t.string :category
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
