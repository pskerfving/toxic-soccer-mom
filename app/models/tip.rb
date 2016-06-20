class Tip < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  after_initialize :reset_tip

  validates_presence_of :user
  validates_presence_of :game
  validates_uniqueness_of :user_id, scope: :game_id

  def reset_tip
    home_score = 0
    away_score = 0
  end

  def calculate_points
    if (home_score == self.game.home_score) && (away_score == self.game.away_score)
      return 3
    elsif (self.home_score <=> self.away_score) == (self.game.home_score <=> self.game.away_score)
      return 2
    end
    0
  end


  def self.game_col game_id
    <<-EOT
   (select sum(points) as total
    from tips t
    where game_id <= #{game_id}  and t.user_id = users.id
    order by total) as g#{game_id}
    EOT
  end

  def self.game_cols
    game_ids.map { |uid| game_col(uid) }.join(', ')
  end

  def self.game_ids
    game_ids ||= Game.where(final: true).order(:id).map(&:id)
  end


  def self.historic_results
    sql = "select name, #{game_cols} from users order by points DESC limit 10"
    recs = ActiveRecord::Base.connection.select_all(sql)
    recs.map do |rec|
      games = game_ids.map {|id| rec["g#{id}"]}
      games.unshift rec['name']
      games
    end
  end

  # om inte unik kombination av user/game, uppdatera befintlig.
end
