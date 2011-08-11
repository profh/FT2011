class OrganizationUser < ActiveRecord::Base
  # relationships
  belongs_to :organization
  belongs_to :user
  
  # validations
  validates_numericality_of :organization_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  
end

# == Schema Information
#
# Table name: organization_users
#
#  id              :integer         not null, primary key
#  organization_id :integer
#  user_id         :integer
#  start_date      :date
#  end_date        :date
#  head            :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

