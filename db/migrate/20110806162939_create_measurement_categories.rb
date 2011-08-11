class CreateMeasurementCategories < ActiveRecord::Migration
  def self.up
    create_table :measurement_categories do |t|
      t.string :title
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :measurement_categories
  end
end
