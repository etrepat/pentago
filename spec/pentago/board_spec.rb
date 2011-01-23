require 'spec_helper'

module Pentago
  describe Board do
    describe '#initialize' do
      it 'should create an empty board' do
        board = Board.new
        board.squares.should == Array.new(Board::SIZE, nil)
      end

      it 'should create a board based on a previous state' do
        # from array
        previous = Array.new(Board::SIZE, nil)
        6.times do |n|
          pos = rand(Board::SIZE+1)
          pos = rand(Board::SIZE+1) while previous[pos]
          previous[pos] = 1 # at this point we don't mind about players
        end

        board = Board.new(previous)
        board.squares.should == previous

        # from another board
        board2 = Board.new(board)
        board2.squares.should == board.squares
      end
      
      it 'should raise TypeError if bad previous state' do
        previous = Hash.new
        expect {
          board = Board.new(previous)
        }.to raise_error(TypeError)
      end
    end

    describe '#place_marker' do
      before(:each) do
        @board = Board.new
      end

      it 'should let us place a marker' do
        @board.place_marker(1, 2, 1)
        @board.squares[13].should == 1
      end

      it 'should raise IllegalPositionError when out of bounds' do
        expect {
          @board.place_marker(6, 8, 1)
        }.to raise_error(Pentago::Board::IllegalPositionError)
      end

      it 'should raise IllegalPositionError if previously occupied' do
        expect do
          @board.place_marker(3, 2, 1)
          @board.place_marker(3, 2, 1)
        end.to raise_error(Pentago::Board::IllegalPositionError)
      end
    end

    describe '#rotate_square' do
      before(:each) do
        @board = Board.new
      end

      it 'should raise InvalidSquareError if invalid square' do
        expect {
          @board.rotate_square(7, :clockwise)
        }.to raise_error(Pentago::Board::InvalidSquareError)
      end

      it 'should raise InvalidDirectionError if invalid direction' do
        expect {
          @board.rotate_square(0, :foowise)
        }.to raise_error(Pentago::Board::InvalidDirectionError)
      end

      it 'should allow us to rotate a square CW/CCW' do
        @board.place_marker(0, 0, 1)
        @board.rotate_square(0, :clockwise)
        @board.squares[2].should == 1

        @board.rotate_square(0, :counter_clockwise)
        @board.squares[0].should == 1
      end

      it 'rotating CW should not affect neighbour squares' do
        @board.place_marker(0, 0, 1)
        @board.rotate_square(0, :clockwise)
        @board.place_marker(3, 1, 2)
        @board.rotate_square(1, :clockwise)
        @board.squares[2].should == 1 && @board.squares[4].should == 2
      end
    end
  end
end

