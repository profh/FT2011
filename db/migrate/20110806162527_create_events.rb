class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :location_id
      t.decimal :cost
      t.integer :max_participants
      t.boolean :permission_required
      t.integer :event_type_id
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
