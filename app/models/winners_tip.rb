class WinnersTip < ActiveRecord::Base
  belongs_to :user
  belongs_to :topscorer_player, :class_name => "Player", :foreign_key => "topscorer_player_id"
  belongs_to :firstswedish_player, :class_name => "Player", :foreign_key => "firstswedish_player_id"

  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winning_team_id"
  belongs_to :runner_up, :class_name => "Team", :foreign_key => "runner_up_id"
  
  
  def caluculate_winners_points(key)
    pt = 0
    if winning_team_id == key.winning_team_id
      pt += 5
    end
    if runner_up_id == key.runner_up_id
      pt += 5
    end
    if topscorer_player_id == key.topscorer_player_id
      pt += 5
    end
    if firstswedish_player_id == key.firstswedish_player_id
      pt += 5
    end
    return pt
  end

end
