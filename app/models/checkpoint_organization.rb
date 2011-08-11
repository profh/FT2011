class CheckpointOrganization < ActiveRecord::Base
  # relationships
   belongs_to :checkpoint
   belongs_to :organization

   # named scopes
   scope :get_existing_orgs, lambda{ |checkpoint_id| select("checkpoint_organizations.id, organizations.name").from("checkpoint_organizations, organizations").where("checkpoint_organizations.organization_id = organizations.id AND checkpoint_organizations.checkpoint_id = ?", checkpoint_id) }   
  
end

# == Schema Information
#
# Table name: checkpoint_organizations
#
#  id              :integer         not null, primary key
#  checkpoint_id   :integer
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

