require 'test_helper'

class QuestionOptionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: question_options
#
#  id          :integer         not null, primary key
#  question_id :integer
#  content     :text
#  points      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

