class MeasurementCategory < ActiveRecord::Base
  # relationships
  has_many :measurements
  has_many :snapshots

  # validations
  validates_presence_of :title

  # named scopes
  scope :alphabetical, order('title')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)


  # total score this user has gotten in questions related to this measurement_category
  def user_score(participant)
    #return rand(30) + 70  # TODO: remove this
    score = 0
    # collect only the responses which are complete and belong to this measurement_category, sum scores
    responses = participant.responses.reject{ |rp|
        (rp.question.measurement.measurement_category.id != id) || (!rp.is_complete?)
    }
    responses.map{|resp| score += resp.points_earned}
    return score
  end
  
  # total possible score this user could have gotten in questions related to this measurement_category
  def total_user_score(participant)
    #return 100  # TODO: remove this
    total = 0
    # collect only the responses which are complete and belong to this measurement_category, sum scores
    responses = participant.responses.reject{ |rp|
        (rp.question.measurement.measurement_category.id != id) || (!rp.is_complete?)
    }
    responses.map{|resp| total += resp.points_total}
    return total
  end

  def organization_score(organization)
    begin
      result = organization.users.map{|usr| self.user_score(usr)}.inject{|sum, score| sum + score}
      return 0 if result.nil?
      result
    rescue
      return 0
    end
  end
  
  def total_organization_score(organization)
    begin
      result = organization.users.map{|usr| self.total_user_score(usr)}.inject{|sum, score| sum + score}
	    return 0 if result.nil?
	    result
	  rescue
	    return 0
    end
  end
  
  def overall_score
    begin
      result = Organization.all.map{|org| self.organization_score(org)}.inject{|sum, score| sum + score}
      return 0 if result.nil?
      result
    rescue
      return 0
    end
  end
  
  def total_overall_score
    begin
      result = Organization.all.map{|org| self.total_organization_score(org)}.inject{|sum, score| sum + score}
	    return 0 if result.nil?
      result
    rescue
      return 0
    end
  end
  
  # SNAPSHOT METHODS
  def overall_snapshot
    begin
      # snapshots = Snapshot.find(:all, where('[measurement_category_id = ?', self.id]))
      snapshots = Snapshot.find_all_by_measurement_category_id(self.id)
      return 0 if snapshots.nil?
      result=(snapshots.map{|sn| sn.percent_score}.inject{|sum, score| sum + score}/snapshots.count)*100
    rescue Exception => e
      return 0
    end
  end
  
  def organization_snapshot(organization)
    begin
      users = organization.users.map{|u| u.id}
      snapshots = Snapshot.where(['measurement_category_id = ? AND user_id IN (?)', self.id, users])
      return 0 if snapshots.nil?
      result=(snapshots.map{|sn| sn.percent_score}.inject{|sum, score| sum + score}/snapshots.count)*100
    rescue Exception => e
      return 0
    end
  end
  
  def user_snapshot(user)
    begin
      user_id = user.id
      snapshots = Snapshot.where(['measurement_category_id = ? AND user_id = ?', self.id, user_id])
      return 0 if snapshots.nil?
      result=(snapshots.map{|sn| sn.percent_score}.inject{|sum, score| sum + score}/snapshots.count)*100
    rescue Exception => e
      return 0
    end
  end
end

# == Schema Information
#
# Table name: measurement_categories
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  active     :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

