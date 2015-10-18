class Tip < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  after_initialize :reset_tip

  validates_presence_of :user
  validates_presence_of :game
  validates_uniqueness_of :user_id, scope: :game_id

  def reset_tip
    home_score = 0
    away_score = 0
  end

  def calculate_points
    if (home_score == self.game.home_score) && (away_score == self.game.away_score)
      return 3
    elsif (self.home_score <=> self.away_score) == (self.game.home_score <=> self.game.away_score)
      return 2
    end
    0
  end


  # om inte unik kombination av user/game, uppdatera befintlig.
end
