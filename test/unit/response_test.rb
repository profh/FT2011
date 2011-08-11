require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: responses
#
#  id                 :integer         not null, primary key
#  question_id        :integer
#  user_id            :integer
#  response_value     :text
#  checkpoint_user_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

