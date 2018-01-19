class CreateGenes < ActiveRecord::Migration[5.1]
  def change
    create_table :genes do |t|
      t.string :name
      t.integer :longitude
      t.integer :latitude
      t.belongs_to :document, foreign_key: true

      t.timestamps
    end
  end
end
