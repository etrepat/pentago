require 'spec_helper'

module Pentago
  describe Game do
    before(:each) do
      @player1  = Pentago::DummyPlayer.new(1)
      @player2  = Pentago::DummyPlayer.new(2)
      @board    = Pentago::Board.new
      @game     = Pentago::Game.new(:player1 => @player1, :player2 => @player2, 
        :board => @board)
    end

    describe '#initialize' do
      it 'should hold player representations' do
        @game.player1.should == @player1
        @game.player2.should == @player2
      end

      it 'should hold a board object' do
        @game.board.should == @board
      end
    end
    
    describe 'instance methods' do
      describe '#play' do
        it 'should alternatively make players play their turn' do
        end
      end      
    end
    
    describe 'rules' do
      before(:each) do
        # full board, no winning conditions
        @full_squares = [1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,2,2,1,2,1,1,1,1,2,1,2,2,
          2,2,1,2,1,1,1,1,2]
          
        # from an actual game, actually this one:
        # http://en.wikipedia.org/wiki/File:Pentago-Game-Winning-Position.jpg
        @winning_squares = [1,1,1,nil,2,nil,nil,2,1,2,2,1,nil,nil,2,1,2,nil,
          nil,1,2,nil,1,nil,2,nil,nil,2,nil,1,nil,nil,nil,nil,nil,nil]
          
        # open board, no full, no winners
        @open_squares = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,
          nil,2,1,2,nil,nil,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
      end
      
      describe '#find_winner' do
        it 'should return nil if no winner' do
          @game.board.squares = @full_squares
          @game.find_winner.should be_nil
        end
        
        it 'should detect a winner when 5 consecutive marbles' do
          @game.board.squares = @full_squares
          @game.board.squares[0] = 2
          @game.board.squares[3] = 1
          @game.board.squares[5] = 2
          @game.find_winner.should be_nil
          
          @game.board.squares[3] = 2
          @game.find_winner.should be(@player2)
        end
        
        it 'should return marble value of winner' do
          @game.board.squares = @full_squares
          @game.board.squares[0] = 2
          @game.find_winner.should be(@player2)
          
          @game.board.squares = @winning_squares
          @game.find_winner.should be(@player1)
          
          @game.board.clear
          # horz.
          Pentago::Board::ROWS.times { |i| @game.board[i,1] = 2 }
          @game.find_winner.should be(@player2)

          # vert.
          @game.board.clear
          Pentago::Board::COLS.times { |i| @game.board[1,i] = 2 }
          @game.find_winner.should be(@player2)

          # center diagonals
          @game.board.clear
          Pentago::Board::ROWS.times { |i| @game.board[i,i] = 2 }
          @game.find_winner.should be(@player2)

          @game.board.clear
          Pentago::Board::ROWS.times { |i| @game.board[5-i,i] = 2 }
          @game.find_winner.should be(@player2)

          # off-center diagonals
          @game.board.clear
          (Pentago::Board::ROWS-1).times { |i| @game.board[i,i+1] = 2 }
          @game.find_winner.should be(@player2)

          @game.board.clear
          (Pentago::Board::ROWS-1).times { |i| @game.board[i+1,i] = 2 }
          @game.find_winner.should be(@player2)

          @game.board.clear
          (Pentago::Board::ROWS-1).times { |i| @game.board[i,4-i] = 2 }
          @game.find_winner.should be(@player2)

          @game.board.clear
          (Pentago::Board::ROWS-1).times { |i| @game.board[i+1,5-i] = 2 }
          @game.find_winner.should be(@player2)

          @game.board.squares = @winning_squares
          @game.find_winner.should be(@player1)

          @game.board.squares = @open_squares
          # play winning move
          @game.board[3,5] = 1
          @game.board.rotate(2, :counter_clockwise)
          @game.find_winner.should be(@player1)
        end
        
        it 'should return nil if more than one winner (tie game)' do
          @game.board.squares = @full_squares
          @game.board.squares[0] = 2
          @game.board.squares[Pentago::Board::SIZE-1] = 1
          @game.find_winner.should be_nil
          
          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
             2,1,2,2,2,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
           @game.board.squares = playing
           @game.board[3,5] = 1
           @game.board.rotate(2, :counter_clockwise)
           @game.find_winner.should be_nil                    
        end
      end
      
      describe '#game_over?' do
        it 'should return true if there is a winner' do
          @game.board.squares = @winning_squares
          @game.find_winner.should be(@player1)
          @game.game_over?.should be_true
        end
        
        it 'should return true if tie game' do
          def @game.tie_game?
            true # force tie
          end
          @game.game_over?.should be_true
        end
      end

      describe '#tie_game?' do
        it 'should return false when game is open (not full)' do
          @game.board.squares = @open_squares
          @game.tie_game?.should be_false
        end
        
        it 'should return true when board is full & no winner, false othw' do
          @game.board.squares = @full_squares
          @game.board.full?.should be_true
          @game.tie_game?.should be_true

          @game.board.squares[0] = 2
          @game.tie_game?.should be_false
        end

        it 'should return false when there is only one winner' do
          @game.board.squares = @full_squares
          @game.board.squares[0] = 2
          @game.tie_game?.should be_false

          @game.board.squares = @winning_squares
          @game.tie_game?.should be_false

          @game.board.squares = @open_squares
          @game.board[3,5] = 1
          @game.board.rotate(2, :counter_clockwise)
          @game.tie_game?.should be_false          
        end

        it 'should return true if two winners at the same time' do
          @game.board.squares = @full_squares
          @game.board.squares[0] = 2
          @game.board.squares[Pentago::Board::SIZE-1] = 1
          @game.tie_game?.should be_true

          playing = [nil,1,2,nil,1,nil,nil,2,nil,nil,2,nil,nil,nil,1,2,nil,nil,
            2,1,2,2,2,2,1,nil,2,nil,nil,1,1,nil,2,nil,1,1]
          @game.board.squares = playing
          @game.board[3,5] = 1
          @game.board.rotate(2, :counter_clockwise)
          @game.tie_game?.should be_true          
        end
      end
    end
  end
end

