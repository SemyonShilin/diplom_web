class CreateRealDataIes < ActiveRecord::Migration[5.1]
  def change
    create_table :real_data_ies do |t|
      t.decimal :percent
      t.integer :latitude
      t.integer :longitude
      t.belongs_to :gene, foreign_key: true
      t.belongs_to :data_x, foreign_key: true
      t.belongs_to :patient, foreign_key: true

      t.timestamps
    end
  end
end