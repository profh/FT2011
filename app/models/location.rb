class Location < ActiveRecord::Base
  # relationships
  has_many :events

  STATES =  ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS",
             "KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY",
             "NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV",
             "WI","WY"]

  # scopes
  scope :alphabetical, order("name")
			 
  # validations
  before_validation :cleanup  
  validates_presence_of :name, :description
  validates_presence_of :street, :city, :state
  validates_inclusion_of  :state, :in => STATES,
                          :message => "state must be an abbreviation of a U.S. State"
  validates_format_of :zip, :with => /\d{5}$/i, 
                      :message => "zip code must be 5 digits"
  validates_format_of :city, :with => /\A([a-zA-z]\s?)+\Z/i,
                      :message => "city can contain only letters and spaces"
  
  # callbacks
  before_save :find_coordinates
    
  
  private
  def find_coordinates
    str = self.street
    town = self.name
    st = self.state
    coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{str}, #{town}, #{st}"
    if coord.success
	    self.lat, self.lon = coord.ll.split(',')
	  else 
	    errors.add_to_base("Error with geocoding")
	  end
  end
  
  def cleanup
    self.title = title.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('title') && (self.title != nil))
    self.description = description.split(".").map{|x| x.capitalize}.join(".") if (attribute_present?('description') && (self.description != nil))
    self.city = city.capitalize if (attribute_present?('city') && (self.city != nil))
    self.state = state.upcase if (attribute_present?('state') && (self.state != nil))
    self.street = street.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street') && (street != nil))
    self.street_2 = street_2.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street_2') && (street_2 != nil))
  end
  
end

# == Schema Information
#
# Table name: locations
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  street      :string(255)
#  street_2    :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  lat         :float
#  lon         :float
#  active      :boolean         default(TRUE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

