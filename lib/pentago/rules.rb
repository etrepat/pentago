module Pentago
  module Rules
    def find_winner
      winners = players_with_5_in_a_row
      if winners.empty? || winners.size > 1
        nil
      else
        winners.first
      end
    end
    
    def game_over?
      winner || tie_game?
    end
    
    def tie_game?
      !winner && (board.full? || players_with_5_in_a_row.size > 1)
    end
    
    private 
    
    def players_with_5_in_a_row
      runs_to_check.map do |run|
        players.map do |player|
          player if run.each_cons(5).any? do |part| 
            part.count(player.marble) == part.size
          end
        end
      end.flatten.compact.uniq
    end
    
    def runs_to_check
      board.rows + board.columns + board.diagonals
    end
  end
end