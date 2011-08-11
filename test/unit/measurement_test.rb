require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: measurements
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  description             :text
#  active                  :boolean         default(TRUE)
#  measurement_category_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

