class CreateCheckpointOrganizations < ActiveRecord::Migration
  def self.up
    create_table :checkpoint_organizations do |t|
      t.integer :checkpoint_id
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoint_organizations
  end
end
