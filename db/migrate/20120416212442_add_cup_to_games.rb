class AddCupToGames < ActiveRecord::Migration
  def change
    add_column :games, :cup_game, :boolean
    add_column :games, :cup_home_score, :integer
    add_column :games, :cup_away_game, :integer
    add_column :games, :cup_final, :boolean    
  end
end
