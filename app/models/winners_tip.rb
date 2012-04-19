class WinnersTip < ActiveRecord::Base
  belongs_to :user
  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winning_team"
  belongs_to :runner_up_team, :class_name => "Team", :foreign_key => "runner_up"
end
