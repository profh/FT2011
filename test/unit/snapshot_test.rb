require 'test_helper'

class SnapshotTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: snapshots
#
#  id                      :integer         not null, primary key
#  measurement_category_id :integer
#  checkpoint_id           :integer
#  user_id                 :integer
#  percent_score           :float
#  created_at              :datetime
#  updated_at              :datetime
#

