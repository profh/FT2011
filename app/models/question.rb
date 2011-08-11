class Question < ActiveRecord::Base
  # relationships
  belongs_to :measurement
  has_many :question_options, :dependent => :destroy
  has_many :responses
  
  # validations
  validates_presence_of :content, :measurement_id, :question_type
  validates_numericality_of :measurement_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :question_type, :in => [1,2,3,4], :message => "is not recognized by the system"

  # named scopes
  scope :last_id, order("id DESC").limit(1)
  scope :get_questions, lambda{ |m_id| select("id, question_type, content, completion_score").where(["measurement_id = ?", m_id]).order("id ASC") }
  
  TYPES = Hash[
    "short_answer" => 1,
    "multiple_choice" => 2,
    "multiple_select" => 3,
    "scale" => 4 
  ]
  
  def question_type_name
    case question_type
    when 1
      return "Short Answer"
    when 2
      return "Multiple Choice"
    when 3
      return "Multiple Select"
    when 4
      return "Scale"
    end
    
  end
  
  def is_shortanswer?
    question_type == TYPES["short_answer"]
  end
  
  def is_multiplechoice?
    question_type == TYPES["multiple_choice"]
  end
  
  def is_multipleselect?
    question_type == TYPES["multiple_select"]
  end
  
  def is_scale?
    question_type == TYPES["scale"]
  end
  
  # check if this question is subjective.
  def is_subjective?
    return (is_shortanswer? or is_scale?)
  end
  
end

# == Schema Information
#
# Table name: questions
#
#  id               :integer         not null, primary key
#  content          :text
#  measurement_id   :integer
#  question_type    :integer
#  completion_score :integer
#  active           :boolean         default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

