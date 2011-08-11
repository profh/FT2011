class Measurement < ActiveRecord::Base
  # relationships
  has_many :questions, :dependent => :destroy
  has_many :events, :through => :event_measurements
  belongs_to :measurement_category

  # validations
  before_validation :cleanup
  validates_presence_of :name


  # named scopes
  scope :alphabetical, order("name ASC")
  scope :get_id, lambda{ |name| select("id").from("measurements").where("name = ?", name) }
 
  def cleanup
    self.name = name.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('name') && (self.name != nil))
    self.description = description.split(".").map{|x| x.capitalize}.join(".") if (attribute_present?('description') && (self.description != nil))
  end
  
end

# == Schema Information
#
# Table name: measurements
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  description             :text
#  active                  :boolean         default(TRUE)
#  measurement_category_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

