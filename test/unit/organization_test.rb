require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  location_id          :integer
#  active               :boolean         default(TRUE)
#  organization_type_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

