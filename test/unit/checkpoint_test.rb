require 'test_helper'

class CheckpointTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: checkpoints
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  due_on      :date
#  distributed :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

