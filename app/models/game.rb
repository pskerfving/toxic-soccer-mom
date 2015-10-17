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
    kickoff < Time.zone.now && !final?
  end

  def started?
    kickoff < Time.zone.now
  end

  def self.first_game_started?
    Game.order(:kickoff).first.kickoff < Time.zone.now
  end

  def reset_score
  end


# Do a faster recalculation of points. Based on the assumption that all users have the right number of points.
# Only the game in @game is considered.
# This is always used when a game ends -> recalculate_points assumes that the tips for all final games have points calculated and stored.
  def recalculate_points_fast!
    if self.final? then
      tips = self.tips
      tips.each do |tip|
        tip.points = tip.calculate_points
        tip.user.points += tip.points
        tip.save!
        tip.user.save!
      end
    end
  end

end
