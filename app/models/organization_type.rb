class OrganizationType < ActiveRecord::Base
  # relationships
  has_many :organizations

  # validations
  validates_presence_of :name
  validates_presence_of :description
  
  # scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
end

# == Schema Information
#
# Table name: organization_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  active      :boolean         default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

