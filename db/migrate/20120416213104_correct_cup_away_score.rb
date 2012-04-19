class CorrectCupAwayScore < ActiveRecord::Migration
  def change
    remove_column :games, :cup_away_game
    remove_column :games, :cup_final

    add_column :games, :cup_away_score, :integer
    add_column :games, :cup_final, :boolean    
  end

end
