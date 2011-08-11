class CreateSnapshots < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|
      t.integer :measurement_category_id
      t.integer :checkpoint_id
      t.integer :user_id
      t.float :percent_score

      t.timestamps
    end
  end

  def self.down
    drop_table :snapshots
  end
end
