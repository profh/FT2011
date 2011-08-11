class Announcement < ActiveRecord::Base
  # validations
  validates_presence_of :body
  validates_presence_of :title
  validates_presence_of :level
  

  # relationships
  belongs_to :organization
  belongs_to :user
  
  # scopes
  scope :chronological, order("created_at DESC")
  scope :last, lambda { |num| limit(num) }
  scope :targeted, lambda { |org_id, lvl| where("(organization_id IS NULL OR organization_id = ?) AND level <= ?", org_id, lvl)}
  scope :admin, where("level <= ? ", User::USER_LEVELS["system_admin"]) 
  scope :for_org, lambda { |id| where("organization_id = ?", id) }
  scope :orgheads, where("level <= ?", User::USER_LEVELS["organization_admin"])
  scope :userview, where("level <= ?", User::USER_LEVELS["participant"])
  scope :expired, where('expires_on < ?', Time.now.to_date)

  def cleanup
    self.title = title.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('title') && (title != nil))
	  self.body = body.capitalize if (attribute_present?('body') && (body != nil))  
  end
  
end

# == Schema Information
#
# Table name: announcements
#
#  id              :integer         not null, primary key
#  body            :text
#  user_id         :integer
#  title           :string(255)
#  expires_on      :date
#  organization_id :integer
#  level           :integer
#  created_at      :datetime
#  updated_at      :datetime
#

