require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: questions
#
#  id               :integer         not null, primary key
#  content          :text
#  measurement_id   :integer
#  question_type    :integer
#  completion_score :integer
#  active           :boolean         default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

