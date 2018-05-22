class CreateRealDataIes < ActiveRecord::Migration[5.1]
  def change
    create_table :real_data_ies do |t|
      t.decimal :percent
      t.integer :latitude
      t.integer :longitude
      t.belongs_to :gene, foreign_key: true
      t.belongs_to :data_x, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :document, foreign_key: true
      t.string :patient_name

      t.timestamps
    end
  end
end
