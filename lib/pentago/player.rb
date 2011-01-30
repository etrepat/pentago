module Pentago
  class Player
    include Pentago::Rules

    def initialize(marble, name='')
      @marble     = marble
      @name       = name
      @last_move  = nil
    end

    attr_reader :marble, :name, :last_move

    def play_turn(board)
      x, y, s, d = compute_next_move(board)
      execute_move(board, x, y, s, d)
      @last_move = [x, y, s, d]
    end

    def compute_next_move(board)
      # to be overriden by subclasses
      raise 'compute_next_move should be overriden by a subclass'
    end

    def execute_move(board, x, y, square, direction)
      board[x, y] = marble
      board.rotate(square, direction)      
    end
    
    def ==(player)
      self.marble == player.marble 
    end
    
    alias_method :eql?, :==
    
    def to_s
      name.empty? ? marble.to_s : name
    end
    
    alias_method :to_str, :to_s
  end
end

