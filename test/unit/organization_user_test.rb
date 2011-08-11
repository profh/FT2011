require 'test_helper'

class OrganizationUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: organization_users
#
#  id              :integer         not null, primary key
#  organization_id :integer
#  user_id         :integer
#  start_date      :date
#  end_date        :date
#  head            :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

