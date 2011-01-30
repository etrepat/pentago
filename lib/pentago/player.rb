module Pentago
  class Player
    def initialize(marble, name='')
      @marble     = marble
      @name       = name
      @last_move  = nil
    end

    attr_reader :marble, :name, :last_move

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
    
    def ==(player)
      self.marble == player.marble 
    end
    
    alias_method :eql?, :==
    
    def to_s
      name.blank? ? marble.to_s : name
    end
    
    alias_method :to_str, :to_s
  end
end

