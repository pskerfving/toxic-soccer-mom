class CorrectNameInGames < ActiveRecord::Migration
  def change
    remove_column :games, :name
    add_column :games, :cup_name, :string
  end
end
