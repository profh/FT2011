class Contact < ActiveRecord::Base
  
  STATES =  ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS",
             "KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY",
             "NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV",
             "WI","WY"]

  CONTACT_RELATIONS = [
    "Mother",
    "Father",
    "Legal Guardian", 
    "Grandparent",
    "Other"
  ]

  # relationships
  belongs_to :user
  
  # validations
  before_validation :cleanup
  validates_presence_of :first_name, :last_name, :phone, :relation
  validates_format_of :first_name, :with => /\A([a-zA-z]\s?)+\Z/i,
                      :message => "first name can contain only letters and spaces"
  validates_format_of :last_name,  :with => /\A([a-zA-Z'-]\s?)+\Z/i,
                                    :message => "last name can contain only letters and spaces"
  validates_format_of :phone, :with => /\d{9}$/i, :message => "must be a valid 9-digit phone number"
  validates_inclusion_of :relation, :in => CONTACT_RELATIONS

  validates_presence_of :line_1, :city, :state
  validates_inclusion_of  :state, :in => STATES,
                          :message => "state must be a the name or abbreviation of a U.S. State"
  validates_format_of :zip, :with => /\d{5}$/i, 
                      :message => "zip code must be 5 digits"
  validates_format_of :city, :with => /\A([a-zA-z]\s?)+\Z/i,
                      :message => "city can contain only letters and spaces"

  def cleanup
    self.first_name = first_name.capitalize if (attribute_present?('first_name') && (self.first_name != nil))
    self.last_name = last_name.capitalize if (attribute_present?('last_name') && (self.last_name != nil))
    self.phone = phone.gsub(/[^0-9]/, "") if (attribute_present?("phone") && (self.phone != nil))
    self.city = city.capitalize if (attribute_present?('city') && (self.city != nil))
    self.state = state.upcase if (attribute_present?('state') && (self.state != nil))
    self.street = street.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street') && (street != nil))
    self.street_2 = street_2.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street_2') && (street_2 != nil))
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

