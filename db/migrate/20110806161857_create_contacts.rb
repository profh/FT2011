class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :user_id
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :first_name
      t.string :last_name
      t.string :relation
      t.integer :category
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
