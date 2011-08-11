require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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

