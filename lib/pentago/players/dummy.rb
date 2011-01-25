module Pentago
  module Players
    class Dummy < Base
      def compute_next_move(board)
        # search for empty space w/ a highly precise algorithm :)
        x, y = rand(Pentago::Board::COLS), rand(Pentago::Board::ROWS)
        while board[x,y]
          x, y = rand(Pentago::Board::COLS), rand(Pentago::Board::ROWS)
        end

        # equally, search for a square to turn? into which direction
        square    = rand(Pentago::Board::SQUARES.size)
        direction = Pentago::Board::ROTATION_DIRECTIONS.sample

        # now return a sure winning move...
        [x, y, square, direction]
      end
    end
  end
end

