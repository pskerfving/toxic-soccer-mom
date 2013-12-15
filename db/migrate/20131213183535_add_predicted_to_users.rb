class AddPredictedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :predicted, :integer

  end
end
