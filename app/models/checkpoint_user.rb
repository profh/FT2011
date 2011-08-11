class CheckpointUser < ActiveRecord::Base
  # relationships
  belongs_to :user
  belongs_to :checkpoint
  has_many :responses
  has_many :questions, :through => :responses

  # indicates whether or not the user has completed the checkpoint.
  def is_complete?
    return !(score == nil)
  end

  # returns percentage of total score that the user got.
  def percent_score
    score = 0
    total = 0
    self.responses.each do |resp|
      if (resp.is_complete?)
        score += resp.points_earned
        total += resp.points_total
      end
    end
    return 100 if (total == 0)
    return (((score * 1.0)/(total*1.0)) * 100).round
  end
end

# == Schema Information
#
# Table name: checkpoint_users
#
#  id            :integer         not null, primary key
#  checkpoint_id :integer
#  user_id       :integer
#  score         :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#

