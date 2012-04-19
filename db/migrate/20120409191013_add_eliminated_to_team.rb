class AddEliminatedToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :eliminated, :boolean

  end
end
