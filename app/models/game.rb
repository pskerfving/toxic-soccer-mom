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
    home_score = 0
    away_score = 0
  end


# Do a faster recalculation of points. Based on the assumption that all users have the right number of points.
# Only the game in @game is considered.
# This is always used when a game ends -> recalculate_points assumes that the tips for all final games have points calculated and stored.
  def recalculate_points_fast!
    if self.final? then
      tips = self.tips
      tips.each do |tip|
        tip.points = tip.calculate_points
        tip.user.points = 0 unless tip.user.points
        tip.user.points += tip.points
        tip.save!
        tip.user.save!
      end
    end
  end

  def self.calculate_odds(games)
    odds_hash = Hash.new
    games.each do |g|
      if g.started?
        odds_hash[g.id] = Hash.new
        odds_hash[g.id][-1] = Float(0)
        odds_hash[g.id][0] = Float(0)
        odds_hash[g.id][1] = Float(0)
        g.tips.each do |t|
          token = t.home_score <=> t.away_score
          odds_hash[g.id][token] += 1
#          (@odds_hash[g.id][token] == nil) ? @odds_hash[g.id][token] = 1 : @odds_hash[g.id][token] += 1
        end # tips-loop

#        @odds_hash[g.id].collect { |i| g.tips.length / i }
        [-1, 0, 1].each do |i|
          if odds_hash[g.id][i] > 0
            odds_hash[g.id][i] = g.tips.length / odds_hash[g.id][i]
          else
            odds_hash[g.id][i] = nil
          end
        end # nbr -> odds - loop
      end # game-loop
    end
    odds_hash
  end

end
