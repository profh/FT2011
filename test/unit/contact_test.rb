require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  street     :string(255)
#  street_2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  relation   :string(255)
#  category   :integer
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

