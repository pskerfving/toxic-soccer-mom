class ChangeWinnersTipsColumnNames < ActiveRecord::Migration
  def change
    rename_column :winners_tips, :winning_team, :winning_team_id
    rename_column :winners_tips, :runner_up, :runner_up_id
  end
end
