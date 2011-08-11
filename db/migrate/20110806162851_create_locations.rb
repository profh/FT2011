class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.float :lat
      t.float :lon
      t.boolean :active, :default => true
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
