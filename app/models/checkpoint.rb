class Checkpoint < ActiveRecord::Base
  # relationships
  has_many :checkpoint_organizations
  has_many :organizations, :through => :checkpoint_organizations
  has_many :checkpoint_users
  has_many :users, :through => :checkpoint_users
  has_many :snapshots

  # scopes
  scope :get_orgs, lambda{ |id| select("organizations.name").from("organizations, checkpoint_organizations, checkpoints").where("organizations.id = checkpoint_organizations.organization_id AND checkpoint_organizations.checkpoint_id = checkpoints.id AND checkpoints.id = ?", id) }   
  
  # validations
  validates_presence_of :name
  validates_presence_of :due_on

  MAX_CHECKPOINT_QUESTIONS = 10000;      # set this to the most questions we allow the user to get in a checkpoint
  
end

# == Schema Information
#
# Table name: checkpoints
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  due_on      :date
#  distributed :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

