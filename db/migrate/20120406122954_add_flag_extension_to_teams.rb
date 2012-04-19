class AddFlagExtensionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :flag_extension, :string

  end
end
