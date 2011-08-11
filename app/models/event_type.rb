class EventType < ActiveRecord::Base
  # relationships
  has_many :events

  # scopes
  scope :alphabetical, order("name")
  scope :active, where('active = ?', true)  
  scope :inactive, where('active = ?', false)
  
  # validations
  validates_presence_of :name
  validates_presence_of :description
end

# == Schema Information
#
# Table name: event_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  active      :boolean         default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

