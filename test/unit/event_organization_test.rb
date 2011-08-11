require 'test_helper'

class EventOrganizationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: event_organizations
#
#  id              :integer         not null, primary key
#  event_id        :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

