class CreateDataXes < ActiveRecord::Migration[5.1]
  def change
    create_table :data_xes do |t|
      t.decimal :percent
      t.integer :latitude
      t.integer :longitude
      t.belongs_to :user, foreign_key: true
      t.belongs_to :document, foreign_key: true

      t.timestamps
    end
  end
end
