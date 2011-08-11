class Response < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :checkpoint_user
  belongs_to :question
  has_one :checkpoint, :through => :checkpoint_user
  has_many :response_options
  
  # scope
  scope :in_order, order("id")
  
  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :question_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :checkpoint_user_id, :only_integer => true, :greater_than => 0
  
  EMPTY_RESPONSE_VALUE = "_"

  # returns false if the response has been filled in by the student
  def is_complete?
    return (response_value != EMPTY_RESPONSE_VALUE)
  end
  
  # returns the value to display for this response in the take_checkpoint form
  def display_value
    if (is_complete?) 
      return response_value
    else
      return ""
    end
  end
  
  # returns the response_options that the student selected in their response
  def selected_question_options
    return response_value.split(",").map{|id_str| id_str.to_i}.map{|id| QuestionOption.find(id)}
  end
  
  # return the number of points the student earned for this response
  def points_earned
    if (question.is_subjective?)
      return question.completion_score
    else
      return selected_question_options.map{|x| x.points}.inject{|sum, score| sum + score}
    end
  end
  
  # return the total points that can be earned for this question
  def points_total
    if (question.is_subjective?)
      return question.completion_score
    elsif (question.is_multiplechoice?)
      return question.question_options.map{|x| x.points}.max
    else
      return question.question_options.map{|x| x.points}.inject{|sum, score| sum + score}
    end
  end
  
  # return's a string indicating which choice(s) or answer(s) the student gave
  def readable_response_value
    if question.is_subjective?
		  return self.response_value
		else
			return self.selected_question_options.map{|sqo| sqo.content}.join("<br />")
		end
  end
  
  def percent_score
    return (((points_earned*1.0)/(points_total*1.0))*100).round
  end
end

# == Schema Information
#
# Table name: responses
#
#  id                 :integer         not null, primary key
#  question_id        :integer
#  user_id            :integer
#  response_value     :text
#  checkpoint_user_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

