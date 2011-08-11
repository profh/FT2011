class Organization < ActiveRecord::Base
  # relationships
  has_many :checkpoint_organizations
  has_many :checkpoints, :through => :checkpoint_organizations
  has_many :organization_users
  has_many :users, :through => :organization_users
  has_many :event_organizations
  has_many :events, :through => :event_organizations
  has_many :announcements
  belongs_to :location
  belongs_to :organization_type
  has_many :snapshots

  # validations
  before_validation :cleanup
  validates_presence_of :name, :organization_type_id, :location_id, :active
  validates_uniqueness_of :name
  
  # named_scope 
  scope :alphabetical, order("name")
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :get_id, lambda{ |name| select("id").where(["name = ?", name]) }
  
  def cleanup
    self.name = name.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('name') && (self.name != nil))
  end
  
  # returns the "at large" family tyes organization. Creates it if it's not in the database already.
  def self.at_large_organization
    
    ft_at_large = Organization.find_by_name("Family Tyes - At Large Organization")
    
    # make the organization, organization type, and location if they doesn't exist.
    if (ft_at_large == nil)
      
      # make location - they have no physical address, use CMU's
      ft_location = Location.find_by_name("Family Tyes' Location")
      if (ft_location == nil)
        ft_location = Location.new({
          "street" => "5000 Forbes Ave",
          "city" => "Pittsburgh",
          "state" => "PA",
          "zip" => "15213",
          "name" => "Family Tyes' Location",
          "description" => "Carnegie Mellon's Campus in Pittsburgh",
          "active" => "true"
        })
        ft_location.save!
      end
    
      # make organization type
      ft_org_type = Organization.find_by_name("Non-profit organization")
      if (ft_org_type == nil)
        # make organization type
        ft_org_type = OrganizationType.find_by_name("Non-profit organization")
        if (ft_org_type == nil)
          ft_org_type = OrganizationType.new({
            "name" => "Non-profit organization",
            "description" => "A non-profit organization",
            "active" => "true"
          })
          ft_org_type.save!
        end
      end
    
      # make organization
      ft_at_large = Organization.new({
        "name" => "Family Tyes - At Large Organization",
        "location_id" => "#{ft_location.id}",
        "active" => "true",
        "organization_type_id" => "#{ft_org_type.id}"
      })
      ft_at_large.save!
    end
    
    return ft_at_large
    
  end
  
  # return organization leaders
  def organization_leaders
    return self.users.reject{|u| u.level != User::USER_LEVELS['organization_admin']}
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  location_id          :integer
#  active               :boolean         default(TRUE)
#  organization_type_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

