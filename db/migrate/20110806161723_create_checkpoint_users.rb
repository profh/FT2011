class CreateCheckpointUsers < ActiveRecord::Migration
  def self.up
    create_table :checkpoint_users do |t|
      t.integer :checkpoint_id
      t.integer :user_id
      t.decimal :score

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoint_users
  end
end
