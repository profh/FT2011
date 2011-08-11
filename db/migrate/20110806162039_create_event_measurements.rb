class CreateEventMeasurements < ActiveRecord::Migration
  def self.up
    create_table :event_measurements do |t|
      t.integer :event_id
      t.integer :measurement_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_measurements
  end
end
