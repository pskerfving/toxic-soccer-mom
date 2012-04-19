class AddPointsToTip < ActiveRecord::Migration
  def change
    add_column :tips, :points, :integer
  end
end
