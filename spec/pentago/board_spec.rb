require 'spec_helper'

module Pentago
  describe Board do
    describe '#initialize' do
      it 'should create an empty board' do
        board = Board.new
        board.squares.should == Array.new(Board::SIZE, nil)
      end
    end

    describe '#restore' do
      it 'should create a board based on a previous state' do
        # from array
        previous = Array.new(Board::SIZE, nil)
        6.times do |n|
          pos = rand(Board::SIZE)
          pos = rand(Board::SIZE) while previous[pos]
          previous[pos] = 1 # at this point we don't mind about players
        end

        board = Board.restore(previous)
        board.squares.should == previous

        # from another board
        board2 = Board.restore(board)
        board2.squares.should == board.squares
      end

      it 'should raise TypeError if bad previous state' do
        previous = Hash.new
        expect {
          board = Board.restore(previous)
        }.to raise_error(TypeError)

        previous = Array.new(Board::SIZE-5, nil)
        expect {
          board = Board.restore(previous)
        }.to raise_error(TypeError)
      end
    end

    describe 'instance methods' do
      before(:each) do
        state = Array.new(Board::SIZE, nil)
        state[7] = :white
        state[14] = :white
        state[10] = :black
        state[22] = :black

        @board = Board.restore(state)

        # a full board with no winning conditions
        @full_board = Board.restore([1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,2,2,1,2,1,1,
          1,1,2,1,2,2,2,2,1,2,1,1,1,1,2])
      end

      describe '#[]' do
        it 'should let us get marble in position' do
          @board[1,1].should == :white
          @board[2,2].should == :white
          @board[4,1].should == :black
          @board[4,3].should == :black
          @board[3,5].should be_nil
        end

        it 'should raise IllegalPosition if accessing out of bounds' do
          expect {
            m = @board[7,3]
          }.to raise_error(Pentago::Board::IllegalPositionError)
        end
      end

      describe '#[]=' do
        it 'should set a marble in position' do
          @board[4,5] = :white
          @board[4,5].should == :white
          @board[4,2] = :black
          @board[4,2].should == :black
        end

        it 'should raise IllegalPosition if accessing out of bounds' do
          expect {
            @board[6,2] = :black
          }.to raise_error(Pentago::Board::IllegalPositionError)
        end

        it 'should raise IllegalPostionError if setting an occupied cell' do
          expect {
            @board[2,2] = :black
          }.to raise_error(Pentago::Board::IllegalPositionError)
        end
      end

      describe '#rotate' do
        it 'should raise InvalidSquareError if invalid square' do
          expect {
            @board.rotate(7, :clockwise)
          }.to raise_error(Pentago::Board::InvalidSquareError)
        end

        it 'should raise InvalidDirectionError if invalid direction' do
          expect {
            @board.rotate(0, :foowise)
          }.to raise_error(Pentago::Board::InvalidDirectionError)
        end

        it 'should allow us to rotate a square CW/CCW' do
          @board[0,0] = 1
          @board.rotate(0, :clockwise)
          @board[2,0].should == 1

          @board.rotate(0, :counter_clockwise)
          @board[0,0].should == 1
        end

        it 'rotating CW should not affect neighbour squares' do
          @board[0,0] = 1
          @board.rotate(0, :clockwise)
          @board[3,1] = 2
          @board.rotate(1, :clockwise)
          @board[2,0].should == 1 && @board[4,0].should == 2
        end
      end

      describe '#full?' do
        it 'should return true when board is full, false otherwise' do
          @board.full?.should be_false
          @full_board.full?.should be_true
        end
      end
      
      describe '#clear' do
        it 'should empty the board (set all positions to nil)' do
          @board.squares.all? { |s| s.nil? }.should be_false
          @board.clear
          @board.squares.all? { |s| s.nil? }.should be_true
        end
      end
    end
  end
end