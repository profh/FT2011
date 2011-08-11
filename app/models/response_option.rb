class ResponseOption < ActiveRecord::Base
  # relationships
  belongs_to :response
  belongs_to :question_option
  
  # validations
  # validates_numericality_of :response_id, :only_integer => true, :greater_than => 0
  # validates_numericality_of :question_option_id, :only_integer => true, :greater_than => 0
  
end

# == Schema Information
#
# Table name: response_options
#
#  id                 :integer         not null, primary key
#  response_id        :integer
#  question_option_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

