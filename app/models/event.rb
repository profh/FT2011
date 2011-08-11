class Event < ActiveRecord::Base
  NOLIMIT_PARTICIPANTS = 100000   # if max_participants is set to this value, we allow unlimited participants.

  # relationships
  belongs_to :event_type
  belongs_to :location
  has_many :event_measurements
  has_many :registrations, :dependent => :destroy
  has_many :event_organizations, :dependent => :destroy
  has_many :organizations, :through => :event_organizations
  has_many :measurements, :through => :event_measurements

  has_many :registrees, :through => :registrations, :class_name => 'User', :source => :user, :order => "last_name, first_name"
  has_many :attendees, :through => :registrations, :class_name => 'User', :source => :user, :conditions => "attended = true", :order => "last_name, first_name"

  # named scopes
  scope :chronological, order("start_date DESC")
  scope :alphabetical, order('name')
  scope :past, where("end_date < ?", Time.now.to_date).order("start_date DESC").limit(4)
  scope :past_all, where("end_date < ?", Time.now.to_date).order("start_date DESC")
  scope :upcoming, where("end_date > ?", Time.now.to_date).order("start_date")
  scope :last_id, order("id DESC").limit(1)
  scope :get_measurements, lambda{ |id| select("measurements.name").from("events, event_measurements, measurements").where("events.id = event_measurements.event_id AND event_measurements.measurement_id = measurements.id AND events.id = ?", id) } 
  
  # validations
  before_validation :cleanup
  validate :validate_date_span
  validates_presence_of :name, :description, :start_date, :end_date, :location_id, :event_type_id
  validates_numericality_of :max_participants, :integer_only => true, :greater_than => 0, :message => "max participants must be a number greater than 0"

  def cleanup
    self.name = name.capitalize if (attribute_present?('name') && (self.name != nil))
    self.description = description.split(".").map{|x| x.capitalize}.join(".") if (attribute_present?('description') && (self.description != nil))
    self.cost = 0.0 if (self.cost == nil)
    self.max_participants = NOLIMIT_PARTICIPANTS if (self.max_participants == nil)
  end

  def validate_date_span
    if (attribute_present?('end_date') && (self.end_date != nil))
  	  errors.add(:end_date, " must come after the start date.") unless self.end_date > self.start_date
	  end
  end

  def max_participants_helper
    if (max_participants != nil && max_participants != NOLIMIT_PARTICIPANTS) then "#{max_participants}" else "(no limit)" end  
  end
  
  def registered?(user_id)
    unless Registration.find_by_user_id_and_event_id(user_id, id)
      return false
    else
      return true
    end
  end
  
  def registration_full?
    if (registration_count() >= max_participants)
      return true
    end
    return false
  end
  
  def registration_count
    
    arr =  Registration.all.reject{|r| r.event_id != id}
    if (arr != []) then return arr.size else return 0 end
  end
  
end

# == Schema Information
#
# Table name: events
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  description         :text
#  location_id         :integer
#  cost                :decimal(, )
#  max_participants    :integer
#  permission_required :boolean
#  event_type_id       :integer
#  start_date          :datetime
#  end_date            :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

