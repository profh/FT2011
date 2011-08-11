class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text :content
      t.integer :measurement_id
      t.integer :question_type
      t.integer :completion_score
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
