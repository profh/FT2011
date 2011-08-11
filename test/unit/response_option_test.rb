require 'test_helper'

class ResponseOptionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: response_options
#
#  id                 :integer         not null, primary key
#  response_id        :integer
#  question_option_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

