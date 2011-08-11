class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :late, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
