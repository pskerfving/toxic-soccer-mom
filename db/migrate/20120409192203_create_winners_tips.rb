class CreateWinnersTips < ActiveRecord::Migration
  def change
    create_table :winners_tips do |t|
      t.integer :user_id
      t.integer :winning_team
      t.integer :runner_up
      t.string :goal_scorer
      t.string :first_swedish_scorer

      t.timestamps
    end
  end
end
