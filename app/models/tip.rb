class Tip < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  after_initialize :reset_tip
  
  def reset_tip
    home_score = 0
    away_score = 0
  end
  
  # om inte unik kombination av user/game, uppdatera befintlig.
end
