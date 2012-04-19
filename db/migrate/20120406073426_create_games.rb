class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_id
      t.integer :away_id
      t.boolean :final
      t.integer :home_score
      t.integer :away_score
      t.integer :group_id
      t.datetime :kickoff

      t.timestamps
    end
  end
end
