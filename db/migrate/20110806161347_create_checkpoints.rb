class CreateCheckpoints < ActiveRecord::Migration
  def self.up
    create_table :checkpoints do |t|
      t.string :name
      t.date :due_on
      t.boolean :distributed

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoints
  end
end
