class AddPlayerToWinnersTips < ActiveRecord::Migration
  def change
    add_column :winners_tips, :topscorer_player_id, :integer
    add_column :winners_tips, :firstswedish_player_id, :integer
  end
end
