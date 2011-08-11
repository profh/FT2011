class Attendance < ActiveRecord::Base
  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :event_id, :only_integer => true, :greater_than => 0

  # relationships
  belongs_to :event
  belongs_to :user
  
  # scopes
  scope :for_user, lambda{ |user_id| where('user_id = ?', user_id) }
  scope :for_event, lambda{ |event_id| where('event_id = ?', event_id) }
  
end

# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  event_id   :integer
#  late       :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

