require 'test_helper'

class MeasurementCategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: measurement_categories
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  active     :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

