require 'test_helper'

class CheckpointOrganizationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: checkpoint_organizations
#
#  id              :integer         not null, primary key
#  checkpoint_id   :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

