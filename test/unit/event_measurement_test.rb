require 'test_helper'

class EventMeasurementTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

