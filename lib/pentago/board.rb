module Pentago
  class Board
    IllegalPositionError  = Class.new(StandardError)
    InvalidSquareError    = Class.new(StandardError)
    InvalidDirectionError = Class.new(StandardError)

    ROTATION_DIRECTIONS = [:clockwise, :counter_clockwise]

    ROTATION_MATRICES = {
      :clockwise          => [2,7,12,-5,0,5,-12,-7,-2],
      :counter_clockwise  => [12,5,-2,7,0,-7,2,-5,-12]
    }

    SQUARES = [
      [ 0, 1, 2, 6, 7, 8,12,13,14],
	    [ 3, 4, 5, 9,10,11,15,16,17],
	    [18,19,20,24,25,26,30,31,32],
	    [21,22,23,27,28,29,33,34,35]
    ]
    
    ROWS = 6
    COLS = 6
    SIZE = 36

    def initialize(other=nil)
      if other
        initialize_from_previous_state(other)
      else
        @squares = Array.new(SIZE, nil)
      end
    end

    attr_reader :squares

    def [](x, y)
      raise IllegalPositionError, "Illegal position [#{x}, #{y}]" unless in_range?(x, y)
      @squares[translate(x, y)]
    end
    
    def []=(x, y, marble)
      raise IllegalPositionError, 'already occupied position' if self[x, y]
      @squares[translate(x, y)] = marble
    end
    
    def rotate(square, direction = :clockwise)
      raise InvalidSquareError, "Invalid square" unless SQUARES[square]
      raise InvalidDirectionError, "Unrecognized direction" \
        unless ROTATION_DIRECTIONS.include?(direction)

      board = squares.dup
      
      iterator = (0..8).to_a
      iterator.reverse! if direction == :counter_clockwise
      
      iterator.each do |p|
        position = SQUARES[square][p]
        marble = squares[position]
        board[position + ROTATION_MATRICES[direction][p]] = marble
      end
      
      @squares = board
    end
        
    def full?
      squares.compact.size == SIZE
    end
    
    def clear
      @squares.replace(Array.new(SIZE, nil))
    end
        
    def find_winner
      # check horizontal lines
      ROWS.times do |y|
        player = self[1,y]
        return player if (player && player == self[2,y] && player == self[3,y] && \
          player == self[4,y] && (player == self[0,y] || player == self[5,y]))
      end
      
      # check vertical lines
      COLS.times do |x|
        player = self[x,1]
        return player if (player && player == self[x,2] && player == self[x,3] && \
          player == self[x,4] && (player == self[x,0] || player == self[x,5]))
      end
      
      # check center diagonal lines
      player = self[1,1]
      return player if (player && player == self[2,2] && player == self[3,3] && \
        player == self[4,4] && (player == self[0,0] || player == self[5,5]))
        
      player = self[4,1]
      return player if (player && player == self[3,2] && player == self[2,3] && \
        player == self[1,4] && (player == self[5,0] || player == self[0,5]))

      # check off-center diagonal lines
      player = self[0,1]
      return player if (player && player == self[1,2] && player == self[2,3] && \
        player == self[3,4] && player == self[4,5])
      
      player = self[1,0]
      return player if (player && player == self[2,1] && player == self[3,2] && \
        player == self[4,3] && player == self[5,4])
      
      player = self[0,4]
      return player if (player && player == self[1,3] && player == self[2,2] && \
        player == self[3,1] && player == self[4,0])
      
      player = self[1,5]
      return player if (player && player == self[2,4] && player == self[3,3] && \
        player == self[4,2] && player == self[5,1])
      
      nil
    end
    
    def game_over?
      full? || find_winner
    end
    
    def tie?
      full? && !find_winner
    end

    def to_s
      output = "\n"
      squares.each_with_index do |value, index|
        if index != 0
          if index % 6 == 0
            output << "\n"
          elsif index % 3 == 0
            output << "|"
          end
				  output << "---------+---------\n" if index % 18 == 0
        end

        output << (value.nil? ? ' . ' : " #{value} ")
      end

      output
    end

    def to_a
      squares
    end

    protected
    
    def translate(x,y)
      x + ROWS*y
    end
    
    def in_range?(x, y)
      r = 0...ROWS
      r.include?(x) && r.include?(y)
    end

    def initialize_from_previous_state(board)
      if board.is_a?(Array) || board.is_a?(Pentago::Board)
        @squares = board.dup.to_a
      else
        raise TypeError, 'Incompatible types'
      end
    end
  end
end

