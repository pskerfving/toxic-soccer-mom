class AddPointsToWinnersTips < ActiveRecord::Migration
  def change
    add_column :winners_tips, :points, :integer
  end
end
