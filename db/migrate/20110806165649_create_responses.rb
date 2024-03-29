class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :question_id
      t.integer :user_id
      t.text :response_value
      t.integer :checkpoint_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
