require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: registrations
#
#  id                       :integer         not null, primary key
#  user_id                  :integer
#  event_id                 :integer
#  authority_id             :integer
#  id_card_id               :integer
#  amount_paid              :decimal(, )
#  permission_form_received :boolean
#  deregistration_date      :date
#  created_at               :datetime
#  updated_at               :datetime
#

