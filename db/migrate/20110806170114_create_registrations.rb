class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :authority_id
      t.integer :id_card_id
      t.decimal :amount_paid
      t.boolean :permission_form_received
      t.date :deregistration_date

      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
