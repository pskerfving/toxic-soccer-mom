class WinnersTip < ActiveRecord::Base
  belongs_to :user
  belongs_to :topscorer_player, :class_name => "Player", :foreign_key => "topscorer_player_id"
  belongs_to :firstswedish_player, :class_name => "Player", :foreign_key => "firstswedish_player_id"

  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winning_team_id"
  belongs_to :runner_up, :class_name => "Team", :foreign_key => "runner_up_id"
end
