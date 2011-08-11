require 'test_helper'

class CheckpointUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: checkpoint_users
#
#  id            :integer         not null, primary key
#  checkpoint_id :integer
#  user_id       :integer
#  score         :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#

