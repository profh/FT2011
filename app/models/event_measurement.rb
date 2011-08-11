class EventMeasurement < ActiveRecord::Base
  # relationships
  belongs_to :event
  belongs_to :measurement

  # scopes
  scope :get_existing_measurements, lambda{ |event_id| select("event_measurements.id, measurements.name").from("event_measurements, measurements").where("event_measurements.measurement_id = measurements.id AND event_measurements.event_id = ?", event_id) } 
  scope :delete_measurement, lambda{ |measurement_id| select("event_measurements.id, measurements.name").from("event_measurements, measurements").where("event_measurements.measurement_id = measurements.id AND event_measurements.event_id = ?", event_id) } 
  
end

# == Schema Information
#
# Table name: event_measurements
#
#  id             :integer         not null, primary key
#  event_id       :integer
#  measurement_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

