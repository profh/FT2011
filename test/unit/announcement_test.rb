require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id              :integer         not null, primary key
#  body            :text
#  user_id         :integer
#  title           :string(255)
#  expires_on      :date
#  organization_id :integer
#  level           :integer
#  created_at      :datetime
#  updated_at      :datetime
#

