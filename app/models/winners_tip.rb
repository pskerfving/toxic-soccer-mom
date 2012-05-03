class WinnersTip < ActiveRecord::Base
  belongs_to :user
  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winning_team_id"
  belongs_to :runner_up, :class_name => "Team", :foreign_key => "runner_up_id"
end
