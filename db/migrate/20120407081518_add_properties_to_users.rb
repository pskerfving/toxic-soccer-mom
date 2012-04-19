class AddPropertiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean

    add_column :users, :cleared, :boolean

  end
end
