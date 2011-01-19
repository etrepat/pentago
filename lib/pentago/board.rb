module Pentago
  class Board
    class BoardError < StandardError; end
    class IllegalPositionError < BoardError; end

    ROTATION_DIRECTIONS = [:clockwise, :counter_clockwise]

    ROTATION_MATRICES = {
      :clockwise => [2,7,12,-5,0,5,-12,-7,-2],
      :counter_clockwise => [12,5,-2,7,0,-7,2,-5,-12]
    }

    SQUARES = [
      [ 0, 1, 2, 6, 7, 8,12,13,14],
	    [ 3, 4, 5, 9,10,11,15,16,17],
	    [18,19,20,24,25,26,30,31,32],
	    [21,22,23,27,28,29,33,34,35]
    ]

    CELLS = 36

    def initialize(options={})
      @squares = Array.new(CELLS, 0)
      initialize_from_previous_state(options[:board]) if options[:board]
    end

    attr_reader :squares

    def place_marker(x, y, marker)
      pos = x + 6*y
      raise IllegalPositionError, "Illegal position [#{x}, #{y}]" unless squares[pos]
      raise IllegalPositionError, "Position already occupied" if squares[pos] != 0

      @squares[pos] = marker
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

        output << (value != 0 ? " #{value} " : ' . ')
      end

      output
    end

    def to_a
      squares
    end

    protected

    def position(x, y)
      x + y*6
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

