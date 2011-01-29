module Pentago
  class Board
    IllegalPositionError  = Class.new(StandardError)
    InvalidSquareError    = Class.new(StandardError)
    InvalidDirectionError = Class.new(StandardError)

    ROTATION_MATRICES = {
      :clockwise          => [2,7,12,-5,0,5,-12,-7,-2],
      :counter_clockwise  => [12,5,-2,7,0,-7,2,-5,-12]
    }

    ROTATION_DIRECTIONS = ROTATION_MATRICES.keys

    SQUARES = [
      [ 0, 1, 2, 6, 7, 8,12,13,14],
	    [ 3, 4, 5, 9,10,11,15,16,17],
	    [18,19,20,24,25,26,30,31,32],
	    [21,22,23,27,28,29,33,34,35]
    ]

    ROWS = COLS = 6
    SIZE = ROWS * COLS

    def initialize
      clear
    end

    attr_accessor :squares

    def [](x, y)
      raise IllegalPositionError, "Illegal position [#{x}, #{y}]" unless in_range?(x, y)
      @squares[translate(x, y)]
    end

    def []=(x, y, marble)
      raise IllegalPositionError, 'already occupied position' if self[x, y]
      @squares[translate(x, y)] = marble
    end

    def rows
      squares.each_slice(ROWS).to_a
    end

    def columns
      rows.transpose
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

    def moves
      squares.compact.size
    end

    def full?
      moves == SIZE
    end

    def clear
      @squares = Array.new(SIZE, nil)
    end
    
    def to_s
      output = "   0  1  2 | 3  4  5 \n"
      output << "  ---------+---------\n"
      output << rows.map.with_index do |row, i|
        row_output = i == 3 ? "  ---------+---------\n#{i}|" : "#{i}|"
        row_output << row.map.with_index do |value, j|
          cell_output = j == 3 ? '|' : ''
          cell_output << (value ? " #{value} " : ' . ')
        end.join
      end.join("\n")
    end
    
    alias_method :to_str, :to_s
    
    def to_a
      squares
    end

    def self.restore(board)
      restored = Board.new
      restored.squares = case
      when board.is_a?(Array)
        raise TypeError, "incompatible board array #{board.size}" if board.size != SIZE
        board.dup
      when board.is_a?(Pentago::Board)
        board.dup.to_a
      else
        raise TypeError, 'incompatible types'
      end

      restored
    end

    private

    def translate(x,y)
      x + ROWS*y
    end

    def in_range?(x, y)
      r = 0...ROWS
      r.include?(x) && r.include?(y)
    end
  end
end

