module Pentago  
  class NegamaxPlayer < Pentago::Player
    include Pentago::Rules
    
    def initialize(marble, name='', search_depth=1)
      super(marble, name)      
      @search_depth = search_depth
    end
    
    attr_accessor :search_depth
    
    def compute_next_move(board)
      available_moves(board).sort_by do |square, rotation|
        x, y = square
        s, d = rotation

        board_copy = board.dup
        board_copy[x, y] = @marble
        board_copy.rotate(s, d)
        
        negamax(board_copy, @search_depth, @marble == 1 ? 2 : 1)
      end.first.flatten
    end
    
    def negamax(board, depth, player, alpha=-1, beta=1)
      return score(board, player) if depth == 0 || board.full?
      
      next_to_move = ((player == 1) ? 2 : 1)
      available_moves(board).each do |square, rotation|
        x, y = square
        s, d = rotation
        
        board_copy = board.dup
        board_copy[x,y] = player
        board_copy.rotate(s, d)
        
        alpha = [alpha, -negamax(board_copy, depth-1, next_to_move, -beta, -alpha)].max
        return beta if alpha >= beta
      end
      alpha
    end
    
    # TODO: improve scoring functions
    def score(board, player)
      opponent = ((player == 1) ? 2 : 1)
      winner = find_winner(board)
      return 1000000 if winner && winner == player
      return -1000000 if winner && winner == opponent
      score_for(board, player) - score_for(board, opponent)
    end
    
    def score_for(board, marble)
      (board.rows + board.columns + board.diagonals).map do |run|
        run.select { |value| value.nil? || value == marble }.size
      end.reduce(&:+)
    end
    
    def available_moves(board)
      board.empty_positions.product(squares.product(directions))
    end
    
    def directions
      Pentago::Board::ROTATION_DIRECTIONS
    end
    
    def squares
      (0...Pentago::Board::SQUARES.size).to_a
    end
  end
end