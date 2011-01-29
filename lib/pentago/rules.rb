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
      board.rows + board.columns + center_diagonals + off_center_diagonals
    end
    
    # TODO: add an algorithm to retrieve diagonals of a generic NxN board
    
    def center_diagonals
      diagonals = []
      diagonals << Board::ROWS.times.map { |r| board[r, r] }
      diagonals << Board::ROWS.times.map { |r| board[Board::ROWS-1-r, r] }
    end
    
    def off_center_diagonals
      diagonals = []
      diagonals << (Board::ROWS-1).times.map { |r| board[r, r+1] }
      diagonals << (Board::ROWS-1).times.map { |r| board[r+1, r] }
      diagonals << (Board::ROWS-1).times.map { |r| board[r,Board::ROWS-2-r] }
      diagonals << (Board::ROWS-1).times.map { |r| board[r+1, Board::ROWS-1-r] }
    end
  end
end