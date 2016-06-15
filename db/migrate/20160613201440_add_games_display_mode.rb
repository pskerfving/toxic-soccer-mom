class AddGamesDisplayMode < ActiveRecord::Migration
  def up
    add_column :users, :games_display_mode, :string, :default => "all"
  end

  def down
    remove_column :users, :games_display_mode
  end
end
