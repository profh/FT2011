class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_hash
      t.string :password_salt
      # Adding some more fields:
      t.string :first_name
      t.string :last_name
      t.string :suffix
      t.boolean :active, :default => true
      t.integer :level
      t.string :gender
      t.string :race
      t.date :birthday
      t.integer :membership_level
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
