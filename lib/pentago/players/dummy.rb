module Pentago
  module Players
    class Dummy < Base
      def play_turn(board)
        # search for empty space w/ highly precise algorithm
        x, y = rand(Pentago::Board::COLS), rand(Pentago::Board::ROWS)
        while board[x,y]
          x, y = rand(Pentago::Board::COLS), rand(Pentago::Board::ROWS)
        end
        
        # which square to turn?
        square    = rand(Pentago::Board::SQUARES.size)
        # in which direction
        direction = Pentago::Board::ROTATION_DIRECTIONS.sample
        
        # execute move
        board[x,y] = marble
        board.rotate(square, direction)
        
        @last_move = [x, y, square, direction]
      end
    end
  end
end