class AddKeyToWinnersTips < ActiveRecord::Migration
  def change
    add_column :winners_tips, :key, :boolean, :default => false
  end
end
