module Pentago
  class Player
    def initialize(marble)
      @marble     = marble
      @last_move  = nil
    end

    attr_reader :marble, :last_move

    def play_turn(board)
      x, y, s, d = compute_next_move(board)
      execute_move(board, x, y, s, d)
    end

    def compute_next_move(board)
      # to be overriden by subclasses
      raise 'compute_next_move should be overriden by a subclass'
    end

    def execute_move(board, x, y, square, direction)
      board[x, y] = marble
      board.rotate(square, direction)
      @last_move = [x, y, square, direction]
    end

    # Note: add common player logic methods here...
  end
end

