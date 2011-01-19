require 'spec_helper'

module Pentago
  describe Board do
    describe '#initialize' do
      it 'should create an empty board' do
        board = Board.new
        board.squares.should == Array.new(Board::CELLS, 0)
      end

      it 'should create a board based on a previous state' do
        # from array
        previous = Array.new(Board::CELLS, 0)
        6.times do |n|
          pos = rand(Board::CELLS+1)
          pos = rand(Board::CELLS+1) while previous[pos] != 0
          previous[pos] = 1 # at this point we don't mind about players
        end

        board = Board.new(:board => previous)
        board.squares.should == previous

        # from another board
        board2 = Board.new(:board => board)
        board2.squares.should == board.squares
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

      it 'should allow us to rotate a square CW' do
        @board.place_marker(0, 0, 1)
        @board.rotate_square(0, :clockwise)
        @board.squares[2].should == 1
      end

      it 'should allow us to rotate a square CCW' do
        @board.place_marker(0, 0, 1)
        @board.rotate_square(0, :clockwise)
        @board.squares[2].should == 1
        @board.rotate_square(0, :counter_clockwise)
        @board.squares[0].should == 1
      end
    end
  end
end

