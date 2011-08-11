class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.text :body
      t.integer :user_id
      t.string :title
      t.date :expires_on
      t.integer :organization_id
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
