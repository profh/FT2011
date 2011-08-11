class QuestionOption < ActiveRecord::Base
  # relationships
  belongs_to :question

  # named scopes
  scope :last_id, order("id DESC").limit(1)
  scope :get_options, lambda{ |qn_id| select("id, content, points").where(["question_id = ?", qn_id]).order("id ASC") }
  
end

# == Schema Information
#
# Table name: question_options
#
#  id          :integer         not null, primary key
#  question_id :integer
#  content     :text
#  points      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

