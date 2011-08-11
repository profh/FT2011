class Registration < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :event
  belongs_to :id_card
  belongs_to :authority, :class_name => 'User', :foreign_key => :id
  
  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :event_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :id_card_id, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_numericality_of :amount_paid, :greater_than_or_equal_to => 0, :allow_nil => true
    
end

# == Schema Information
#
# Table name: registrations
#
#  id                       :integer         not null, primary key
#  user_id                  :integer
#  event_id                 :integer
#  authority_id             :integer
#  id_card_id               :integer
#  amount_paid              :decimal(, )
#  permission_form_received :boolean
#  deregistration_date      :date
#  created_at               :datetime
#  updated_at               :datetime
#

