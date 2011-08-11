class CreateIdCards < ActiveRecord::Migration
  def self.up
    create_table :id_cards do |t|
      t.integer :user_id
      t.string :bar_code
      t.datetime :assigned_on

      t.timestamps
    end
  end

  def self.down
    drop_table :id_cards
  end
end
