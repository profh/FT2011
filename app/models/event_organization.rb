class EventOrganization < ActiveRecord::Base
  # relationships
  belongs_to :event
  belongs_to :organization
end

# == Schema Information
#
# Table name: event_organizations
#
#  id              :integer         not null, primary key
#  event_id        :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

