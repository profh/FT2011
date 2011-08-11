class IdCard < ActiveRecord::Base
  # relationships
  belongs_to :user

  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_presence_of :bar_code
  
  # callbacks
  before_create :set_assigned_on
  
  def set_assigned_on
    self.assigned_on = Time.now
  end
  
end

# == Schema Information
#
# Table name: id_cards
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  bar_code    :string(255)
#  assigned_on :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

