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

          @full_board.full?.should be_true
        end
      end

      describe '#tie?' do
        it 'should return false when game is open (not full)' do
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.restore(playing)

          board.tie?.should be_false
        end

        it 'should return false when there is only one winner' do
          @full_board.squares[0] = 2
          @full_board.tie?.should be_false

          # from an actual game, actually this one:
          # http://en.wikipedia.org/wiki/File:Pentago-Game-Winning-Position.jpg
          winning = [1,1,1,nil,2,nil,nil,2,1,2,2,1,nil,nil,2,1,2,nil,nil,1,2,
            nil,1,nil,2,nil,nil,2,nil,1,nil,nil,nil,nil,nil,nil]
          board = Board.restore(winning)
          board.tie?.should be_false

          # from an actual game, move example on box:
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.restore(playing)
          # play winning move
          board[3,5] = 1
          board.rotate(2, :counter_clockwise)
          board.tie?.should be_false
        end

        it 'should return true when board is full & no winner' do
          @full_board.tie?.should be_true

          @full_board.squares[0] = 2
          @full_board.tie?.should be_false
        end

        it 'should return true if two winners at the same time' do
          @full_board.squares[0] = 2
          @full_board.squares[Board::SIZE-1] = 1
          @full_board.tie?.should be_true

          # from an actual game, move example on box:
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,2,2,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.restore(playing)
          # play winning move
          board[3,5] = 1
          board.rotate(2, :counter_clockwise)
          board.tie?.should be_true
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
        it 'should return nil if no winner' do
          # empty board
          @board.clear
          @board.find_winner.should be_nil

          # from an actual game, move example on box:
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.restore(playing)
          board.find_winner.should be_nil
        end

        it 'should return marble value of winner player' do
          # empty board
          @board.clear

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
          board = Board.restore(winning)
          board.find_winner.should == 1

          # from an actual game, move example on box:
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          board = Board.restore(playing)
          # play winning move
          board[3,5] = 1
          board.rotate(2, :counter_clockwise)
          board.find_winner.should == 1
        end
      end
    end
  end
end

