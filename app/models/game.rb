class Game < ActiveRecord::Base

  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_id"
  belongs_to :away_team, :class_name => "Team", :foreign_key => "away_id"
  belongs_to :group

  has_many :tips
  has_many :comments, :as => :commentable

#  validate :valid_group_game

  after_initialize :reset_score

  # Denna ska inte användas. Game skulle inte haft ett grupp-fält över huvud taget.
  def valid_group_game
    if group_id == 0 then return end
    if home_team.group_id != group_id
      errors.add(:home_id, "must be a team from the group.")
    end
    if away_team.group_id != group_id
      errors.add(:away_id, "must be a team from the group.")
    end
  end
  
  def name
    home_team.abbreviation + " - " + away_team.abbreviation
  end

  # Return
  def ongoing?
    return kickoff < Time.zone.now && !final?
  end

  def started?
    return kickoff < Time.zone.now
  end

  def reset_score
  end
    
end
