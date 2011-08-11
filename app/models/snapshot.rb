class Snapshot < ActiveRecord::Base
  # relationships
  belongs_to :checkpoint
  belongs_to :user
  belongs_to :measurement_category
  
  # validations
  validates_numericality_of :measurement_category_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :checkpoint_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  
end

# == Schema Information
#
# Table name: snapshots
#
#  id                      :integer         not null, primary key
#  measurement_category_id :integer
#  checkpoint_id           :integer
#  user_id                 :integer
#  percent_score           :float
#  created_at              :datetime
#  updated_at              :datetime
#

