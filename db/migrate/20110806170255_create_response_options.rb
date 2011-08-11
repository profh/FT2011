class CreateResponseOptions < ActiveRecord::Migration
  def self.up
    create_table :response_options do |t|
      t.integer :response_id
      t.integer :question_option_id

      t.timestamps
    end
  end

  def self.down
    drop_table :response_options
  end
end
