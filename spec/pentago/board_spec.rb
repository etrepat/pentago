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
          pos = rand(Board::SIZE)
          pos = rand(Board::SIZE) while previous[pos]
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
        
        previous = Array.new(Board::SIZE-5, nil)
        expect {
          board = Board.new(previous)
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
        @board = Board.new(state)
      end
      
      def fill_board(board)
        board_copy = board.dup
        players = [:white, :black].cycle
        Board::COLS.times do |x|
          Board::ROWS.times do |y|
            marble = board[x,y]
            board[x,y] = players.next unless marble
          end
        end
        board_copy
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
          @board = fill_board(@board)
          @board.full?.should be_true
        end
      end
      
      describe '#clear' do
        it 'should empty the board (set all positions to nil)' do
          @board.squares.all? { |s| s.nil? }.should be_false
          @board.clear
          @board.squares.all? { |s| s.nil? }.should be_true
        end
      end
      
      describe '#find_winner' do
        it 'should return the marble value of winner player, nil otherwise' do
          # empty board
          @board.clear
          @board.find_winner.should be_nil
          
          # horz.
          @board[0,1] = @board[1,1] = @board[2,1] = @board[3,1] = @board[4,1] = 2
          @board.find_winner.should == 2
          
          # vert.
          @board.clear
          @board[1,1] = @board[1,2] = @board[1,3] = @board[1,4] = @board[1,5] = 2
          @board.find_winner.should == 2
          
          # center diagonals
          @board.clear
          @board[0,0] = @board[1,1] = @board[2,2] = @board[3,3] = @board[4,4] = 2
          @board.find_winner.should == 2
          
          @board.clear
          @board[5,0] = @board[4,1] = @board[3,2] = @board[2,3] = @board[1,4] = 2
          @board.find_winner.should == 2
          
          # off-center diagonals
          @board.clear
          @board[0,1] = @board[1,2] = @board[2,3] = @board[3,4] = @board[4,5] = 2
          @board.find_winner.should == 2
          
          @board.clear
          @board[1,0] = @board[2,1] = @board[3,2] = @board[4,3] = @board[5,4] = 2
          @board.find_winner.should == 2
          
          @board.clear
          @board[0,4] = @board[1,3] = @board[2,2] = @board[3,1] = @board[4,0] = 2
          @board.find_winner.should == 2
          
          @board.clear
          @board[1,5] = @board[2,4] = @board[3,3] = @board[4,2] = @board[5,1] = 2
          @board.find_winner.should == 2
          
          # from an actual game, actually this one:
          # http://en.wikipedia.org/wiki/File:Pentago-Game-Winning-Position.jpg
          winning = [1,1,1,nil,2,nil,nil,2,1,2,2,1,nil,nil,2,1,2,nil,nil,1,2,
            nil,1,nil,2,nil,nil,2,nil,1,nil,nil,nil,nil,nil,nil]
          board = Board.new(winning)
          board.find_winner.should == 1
          
          # from an actual game, move example on box:
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.new(playing)
          board.find_winner.should be_nil          
          # play winning move
          board[3,5] = 1
          board.rotate(2, :counter_clockwise)
          board.find_winner.should == 1
        end
      end
    end
  end
end

