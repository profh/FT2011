require 'test_helper'

class AttendanceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  event_id   :integer
#  late       :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

