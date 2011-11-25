module Pentago
  class DummyPlayer < Player
    def compute_next_move
      # search for empty space w/ a highly precise algorithm :)
      begin
        x, y = rand(Board::COLS), rand(Board::ROWS)
      end while @board[x,y]

      # equally, search for a square to turn? into which direction
      square    = rand(Board::SQUARES.size)
      direction = Board::ROTATION_DIRECTIONS.sample

      # now return a sure winning move...
      [x, y, square, direction]
    end
  end
end
