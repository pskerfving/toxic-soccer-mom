class AddWineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wine, :boolean, :default => false

  end
end
