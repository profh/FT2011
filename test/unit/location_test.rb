require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: locations
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  street      :string(255)
#  street_2    :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  lat         :float
#  lon         :float
#  active      :boolean         default(TRUE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

