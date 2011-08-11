class CreateEventOrganizations < ActiveRecord::Migration
  def self.up
    create_table :event_organizations do |t|
      t.integer :event_id
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_organizations
  end
end
