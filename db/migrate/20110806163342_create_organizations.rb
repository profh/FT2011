class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.integer :location_id
      t.boolean :active, :default => true
      t.integer :organization_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
