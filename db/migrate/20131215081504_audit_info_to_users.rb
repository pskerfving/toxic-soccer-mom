class AuditInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved_by_id, :integer
    add_column :users, :approved_at, :datetime
    add_column :users, :wine_by_id, :integer
    add_column :users, :wine_at, :datetime
  end
end
