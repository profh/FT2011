class CreateOrganizationTypes < ActiveRecord::Migration
  def self.up
    create_table :organization_types do |t|
      t.string :name
      t.text :description
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_types
  end
end
