class CreateOrganizationUsers < ActiveRecord::Migration
  def self.up
    create_table :organization_users do |t|
      t.integer :organization_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.boolean :head

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_users
  end
end
