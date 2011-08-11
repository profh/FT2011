class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :first_name, :last_name, :suffix, :active, :level, :gender, :race, :birthday, :membership_level, :street, :street_2, :city, :state, :zip, :phone, :role
  
  # relationships
  has_many :registrations, :dependent => :destroy
  has_many :events, :through => :registrations
  has_many :organization_users, :dependent => :destroy
  has_many :organizations, :through => :organization_users
  has_many :checkpoint_users, :dependent => :destroy
  has_many :checkpoints, :through => :checkpoint_users
  has_many :announcements
  has_many :id_cards
  has_one :contact
  has_many :responses
  has_many :snapshots
  
  attr_accessor :password
  before_save :prepare_password

  STATES =  ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS",
             "KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY",
             "NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV",
             "WI","WY"]

  GENDERS = ["Male", "Female"]

  RACES = [ "White or Caucasian",         
            "Black or African American",
            "Asian or Pacific Islander",
            "Latino, Hispanic, or Spanish Origin",
            "American Indian" ]

  USER_LEVELS = Hash[
    "participant" => 10,
    "organization_admin" => 30,
    "system_admin" => 50 
  ]  

  # validations
  before_validation :cleanup
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  validates_presence_of :first_name, :last_name, :phone, :birthday
  validates_format_of :first_name, :with => /\A([a-zA-z]\s?)+\Z/i, :message => "first name can contain only letters and spaces"
  validates_format_of :last_name,  :with => /\A([a-zA-Z'-]\s?)+\Z/i, :message => "last name can contain only letters and spaces"
  validates_format_of :phone, :with => /\d{9}$/i, :message => "must be a valid 9-digit phone number" 
  validates_presence_of :street, :city, :state
  validates_inclusion_of  :state, :in => STATES, :message => "state must be an abbreviation of a U.S. State"
  validates_format_of :zip, :with => /\d{5}$/i, :message => "zip code must be 5 digits"
  validates_format_of :city, :with => /\A([a-zA-z]\s?)+\Z/i, :message => "city can contain only letters and spaces"
  validates_presence_of :email, :username
                      
  # named scope
  scope :participants, where(['level = ?', USER_LEVELS["participant"]])
  scope :admins, where(['level = ?', USER_LEVELS["system_admin"]])
  scope :orgleaders, where(['level = ?', USER_LEVELS["organization_admin"]])
  scope :leaders, where(['level = ?', USER_LEVELS["organization_admin"]])
  scope :female_participants, where(['gender = ? and level <= ?', "Female", USER_LEVELS["participant"]])
  scope :male_participants, where(['gender = ? and level <= ?', "Male", USER_LEVELS["participant"]])
  scope :get_age_5_10, lambda{ |id| select("id").where(["(date('now')-birthday) >=5 AND (date('now')-birthday) <= 10", id]) }
  scope :get_age_11_15, lambda{ |id| select("id").where(["(date('now')-birthday) >=11 AND (date('now')-birthday) <= 15", id]) }
  scope :get_age_16_20, lambda{ |id| select("id").where(["(date('now')-birthday) >=16 AND (date('now')-birthday) <= 20", id]) }
  scope :get_age_21_over, lambda{ |id| select("id").where(["(date('now')-birthday) >=21", id]) }
  scope :race_white, where(['race = ?', "White or Caucasian"])
  scope :race_black, where(['race = ?', "Black or African American"])
  scope :race_spanish, where(['race = ?', "Latino, Hispanic, or Spanish Origin"])
  scope :race_asian, where(['race = ?', "Asian or Pacific Islander"])
  scope :race_americanindian, where(['race = ? and level <= ?', "American Indian", USER_LEVELS["participant"]])
  scope :female, where(['gender = ?', "Female"])
  scope :male, where(['gender = ?', "Male"])
  # named_scope :completep, :conditions => ['birthday != ? AND gender != ? AND race != ? AND level <= ?', "", "", "", USER_LEVELS["participant"]]
  scope :completep, where(['birthday IS NOT NULL AND gender IS NOT NULL AND race IS NOT NULL AND level <= ?',  USER_LEVELS["participant"]])
  
  def capwords(phrase)
    return true if phrase.nil? || phrase == ""
    words = phrase.split
    revised = %w[]
    words.each do |word|
      if word.match(/-/)
        revised << word.split("-").map{|w| w.capitalize}.join("-")
      else
        revised << word.capitalize
      end
    end
    final = revised.join(" ")  
  end

  # cleans up user input from creating user
  def cleanup
    self.city = capwords(city) if (attribute_present?('city') && (self.city != nil))
    self.state = state.upcase if (attribute_present?('state') && (self.state != nil))
    self.street = street.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street') && (street != nil))
    self.street_2 = street_2.split(" ").map{|x| x.capitalize}.join(" ") if (attribute_present?('street_2') && (street_2 != nil))
    self.phone = phone.split("-").join("").split(".").join("") if (attribute_present?('phone') && (phone != nil))
    self.first_name = capwords(first_name) if (attribute_present?('first_name') && (first_name != nil))
    self.last_name = capwords(last_name) if (attribute_present?('last_name') && (last_name != nil))
  end
 
  # gives the user's age 
  def age
    return 0 if birthday.nil?
    now = Date.today
    year = now.year - birthday.year	
    
    if (birthday.yday) > now.yday
      year = year - 1
    end
	  year
  end
  
  # returns true if user is an admin, false otherwise
  def is_admin?
    level >= USER_LEVELS["system_admin"]
  end

  # returns true if user is an organization_admin, false otherwise
  def is_organization_admin?
    #self.is_head?
    level >= USER_LEVELS["organization_admin"] && level <= USER_LEVELS["system_admin"]
  end
  
  def is_orgleader?
    #self.is_head?
    level = USER_LEVELS["organization_admin"]
  end
  
  # returns true if user is an organization head, false otherwise
  def is_head?
    heads = self.organization_users.collect{|ou| ou if ou.head == true}
    heads.delete(nil)
    return heads.size > 0
  end

  # true if the user is a participant user level or lower. false otherwise.
  def is_participant?
     level <= USER_LEVELS["participant"]
  end

  # gives the user's full name
  def full_name
    if !first_name && !last_name
      return "New User"
    else
      return first_name + " " + last_name
    end
  end
  
  # NIFTY AUTHENTICATION: login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
  
  #====================
  # CHECKPOINT HELPERS
  #==================== 

  # gives a list of events user has attended before now but after their last checkpoint.
  def events_since_last_checkpoint

    # get last checkpoint, and set of past events
    last_cp = checkpoint_users.sort{|c1,c2| c2.created_at <=> c1.created_at}.first
    if registrations.nil?
      events == false
    else
      events = registrations.map{|reg| reg.event}.reject{|e| e.start_date > Date.today}
    end

    # reject any events that were subject to a previous checkpoint
    if !events
      events_since_last = Array.new
    else
      if (last_cp == nil)
        events_since_last = events.sort{|e1,e2| e1.start_date <=> e2.start_date}
      else
        events_since_last = events.reject{|e| e.start_date < last_cp.created_at}.sort{|e1,e2| e1.start_date <=> e2.start_date}
      end
    end

    events_since_last
  end
  
  def org_ids

     organization_users.each do |org|
        if  self.is_head? && id == org.user_id
          return org.organization_id
        end
      end
  end


  #check if user has pending checkpoint
  def has_checkpoint?
    checkpoint_users.each do |check_user|
      return true if !check_user.is_complete?
    end
    return false
  end
  
  def has_updated?
    return false if !first_name && !last_name
    return true
  end
  
  # generate a random password to give to a new user account
  def self.generate_random_password
    nouns = %w(trout bass sunfish marlin shark catfish tuna zebrafish clownfish swordfish angelfish goldfish seahorse guppy stingray whale crab dolphin)
    verbs = %w(awesome fishy big small colorful)
    specials = %w(_ ~ - + * - & ^ % $ # @ !)
    return verbs[rand(verbs.length)] + specials[rand(specials.length)] + nouns[rand(nouns.length)] + "#{rand(100)}"
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id               :integer         not null, primary key
#  username         :string(255)
#  email            :string(255)
#  password_hash    :string(255)
#  password_salt    :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  suffix           :string(255)
#  active           :boolean         default(TRUE)
#  level            :integer
#  gender           :string(255)
#  race             :string(255)
#  birthday         :date
#  membership_level :integer
#  street           :string(255)
#  street_2         :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  phone            :string(255)
#  role             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

