require 'test_helper'

class OrganizationTypeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: organization_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  active      :boolean         default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

