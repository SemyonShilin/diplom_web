class CreateGenes < ActiveRecord::Migration[5.1]
  def change
    create_table :genes do |t|
      t.string :name
      t.integer :longitude
      t.integer :latitude

      t.timestamps
    end
  end
end
