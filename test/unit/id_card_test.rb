require 'test_helper'

class IdCardTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: id_cards
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  bar_code    :string(255)
#  assigned_on :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

