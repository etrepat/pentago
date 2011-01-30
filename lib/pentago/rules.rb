module Pentago
  module Rules
    def find_winner(board)
      winners = players_with_5_in_a_row(board)
      if winners.empty? || winners.size > 1
        nil
      else
        winners.first
      end      
    end
    
    def check_game_over(board)
      find_winner(board) || check_tie_game(board)
    end
    
    def check_tie_game(board)
      !find_winner(board) && (board.full? || players_with_5_in_a_row(board).size > 1)
    end
    
    private 
    
    def players_with_5_in_a_row(board)
      player_marbles = board.squares.compact.uniq      
      runs_to_check(board).map do |run|
        player_marbles.map do |marble|
          marble if run.each_cons(5).any? do |part| 
            part.count(marble) == part.size
          end
        end
      end.flatten.compact.uniq
    end
    
    def runs_to_check(board)
      board.rows + board.columns + board.diagonals
    end
  end
end